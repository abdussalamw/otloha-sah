import cv2
import numpy as np
from PIL import Image, ImageDraw


# input: img:cv2 image, template: cv2 image
# output: image sliced
# note: take (RGB) image
def remove_frame(img_rgb, template):
    img_gray = cv2.cvtColor(img_rgb, cv2.COLOR_BGR2GRAY)
    template = cv2.resize(template, (int(img_gray.shape[1]), int(img_gray.shape[0] - (img_gray.shape[0] * 0.07))),
                          interpolation=cv2.INTER_AREA)

    w, h = template.shape[::-1]
    methods = ['cv2.TM_CCOEFF', 'cv2.TM_CCOEFF_NORMED', 'cv2.TM_CCORR_NORMED', 'cv2.TM_SQDIFF', 'cv2.TM_SQDIFF_NORMED']

    for meth in methods:
        img = img_gray.copy()
        method = eval(meth)
        res = cv2.matchTemplate(img, template, method)
        min_val, max_val, min_loc, max_loc = cv2.minMaxLoc(res)

        # If the method is TM_SQDIFF or TM_SQDIFF_NORMED, take minimum
        if method in [cv2.TM_SQDIFF, cv2.TM_SQDIFF_NORMED]:
            top_left = min_loc
        else:
            top_left = max_loc
        bottom_right = (top_left[0] + w, top_left[1] + h)

        border_width = 40
        padding = 7
        inner_width = 518
        line_height = 56
        outer_frame = border_width + padding
        inner_top_left = (top_left[0] + outer_frame, top_left[1] + outer_frame)
        inner_bottom_right = (bottom_right[0] - outer_frame, bottom_right[1] - outer_frame)

        return img_rgb[inner_top_left[1]:inner_bottom_right[1], inner_top_left[0]:inner_bottom_right[0]]


# input: cv2 image
def crop_black(img):
    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    th, threshed = cv2.threshold(gray, 0, 255, cv2.THRESH_OTSU)

    ## (2) Morph-op to remove noise
    kernel = cv2.getStructuringElement(cv2.MORPH_ELLIPSE, (11, 11))
    morphed = cv2.morphologyEx(threshed, cv2.MORPH_CLOSE, kernel)

    ## (3) Find the max-area contour
    cnts = cv2.findContours(morphed, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)[-2]
    cnt = sorted(cnts, key=cv2.contourArea)[-1]
    x, y, w, h = cv2.boundingRect(cnt)
    return img[y:y + h, x:x + w]


# input PIL image
def frame_remover(img):
    # make black bg
    img_black_bg = make_black_bg(img)
    img_cv = crop_black(numpy.array(img_black_bg))

    border_width = 40
    padding = 7
    line_height = 56
    w, h = img_cv.shape[0], img_cv.shape[1]
    img_cv = img_cv[38:w - 38, 38: h - 38]
    return Image.fromarray(img_cv).convert('RGBA')


# input: img: cv2 image
# note the background image must be black
def crop(img):
    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    th, threshed = cv2.threshold(gray, 240, 255, cv2.THRESH_BINARY_INV)

    ## (2) Morph-op to remove noise
    kernel = cv2.getStructuringElement(cv2.MORPH_ELLIPSE, (11, 11))
    morphed = cv2.morphologyEx(threshed, cv2.MORPH_CLOSE, kernel)

    ## (3) Find the max-area contour
    cnts = cv2.findContours(morphed, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)[-2]
    cnt = sorted(cnts, key=cv2.contourArea)[-1]
    x, y, w, h = cv2.boundingRect(cnt)
    dst = img[y:y + h, x:x + w]
    W, H = dst.shape[0], dst.shape[1]
    return dst
    # return dst[79:W - 38, 38: H - 38]


def make_transparent(img):
    # this script is from http://stackoverflow.com/questions/5365589
    # it converts a white background to be transparent

    # split the number into r, g, b
    # threshold is how high each of r/g/b must be considered to
    # remove it (keeping in mind that white is 255).
    threshold = 200

    # in theory, lowering dist ensures more gray colors
    # are eliminated - but in practice, i found that ignoring
    # the dist parameter returned better results.
    dist = 5
    use_dist = False
    img = cv2.cvtColor(img, cv2.COLOR_BGR2BGRA)
    # np.asarray(img) is read only. Wrap it in np.array to make it modifiable.
    r, g, b, a = np.rollaxis(img, axis=-1)
    mask = ((r > threshold)
            & (g > threshold)
            & (b > threshold))
    if use_dist:
        mask = (mask
                & (np.abs(r - g) < dist)
                & (np.abs(r - b) < dist)
                & (np.abs(g - b) < dist))
    img[mask, 3] = 0

    return img


# input: CV2 image
# output: cv2 image
def make_white_bg(img):
    img = img.convert('RGBA')
    bg = Image.new(img.mode, img.size, (255, 255, 255, 1))
    i = Image.alpha_composite(bg, img)
    return i


def make_black_bg(img):
    bg = Image.new(img.mode, img.size, (0, 0, 0))
    i = Image.alpha_composite(bg, img)
    return i


# input: img_rgb: cv2 image, template: cv2 image
def detect_basmala(img_rgb, template):
    # heavily based on the "template matching" tutorial for opencv python

    def is_x_in_range(x_range, pt):
        if x_range[0] <= pt[0] <= x_range[1]:
            return True, False
        elif pt[0] >= x_range[0] and pt[0] - x_range[1] < 10:
            return True, True
        elif pt[0] <= x_range[1] and x_range[0] - pt[0] < 10:
            return True, True
        return False, False

    def is_y_in_range(y_range, pt):
        if y_range[0] <= pt[1] <= y_range[1]:
            return True, False
        elif pt[1] >= y_range[0] and pt[1] - y_range[1] < 10:
            return True, True
        elif pt[1] <= y_range[1] and y_range[1] - pt[1] < 10:
            return True, True
        return False, False

    def process(ayat):
        result = []
        cur_y = ayat[0][1]
        same_line = []
        for ayah in ayat:
            if abs(ayah[1] - cur_y) < 20:
                same_line.append(ayah)
            else:
                same_line.sort(key=lambda tup: tup[0])
                for s in same_line[::-1]:
                    result.append(s)
                cur_y = ayah[1]
                same_line = [ayah]

        same_line.sort(key=lambda tup: tup[0])
        for s in same_line[::-1]:
            result.append(s)
        return result

    def find_basmala(img_gray, template, threshold=0.4):
        w, h = template.shape[::-1]

        res = cv2.matchTemplate(img_gray, template, cv2.TM_CCOEFF_NORMED)
        loc = np.where(res >= threshold)

        points = list(zip(*loc[::-1]))
        ayat = []
        if len(points) == 0:
            return ayat

        extras = []
        x_range = (points[0][0], points[0][0])
        y_range = (points[0][1], points[0][1])
        actual_y_range = y_range

        for pt in points:
            x_in_range, should_expand_x = is_x_in_range(x_range, pt)
            y_in_range, should_expand_y = is_y_in_range(y_range, pt)

            if x_in_range and y_in_range:
                if should_expand_x:
                    x_range = (min(pt[0], x_range[0]), max(pt[0], x_range[1]))
                if should_expand_y:
                    y_range = (min(pt[1], y_range[0]), max(pt[1], y_range[1]))
                    actual_y_range = y_range
            elif y_in_range:
                # more than one ayah lives on this line
                added = False
                for i in range(0, len(extras)):
                    e = extras[i]
                    in_range, expand_x = is_x_in_range(e, pt)
                    if in_range:
                        if expand_x:
                            extras[i] = (min(e[0], pt[0]), max(pt[0], e[1]), e[2], e[3])
                        in_y_range, expand_y = is_y_in_range(e, pt)
                        if expand_y:
                            extras[i] = (e[0], e[1], min(e[2], pt[1]), max(e[3], pt[1]))
                        added = True
                        break
                if not added:
                    extras.append((pt[0], pt[0], pt[1], pt[1]))
                if should_expand_y:
                    y_range = (min(pt[1], y_range[0]), max(pt[1], y_range[1]))
            else:
                x_avg = (x_range[0] + x_range[1]) / 2
                y_avg = (actual_y_range[0] + actual_y_range[1]) / 2
                ayat.append((x_avg, y_avg))
                x_range = (pt[0], pt[0])
                y_range = (pt[1], pt[1])
                actual_y_range = y_range
                for e in extras:
                    e_x_avg = (e[0] + e[1]) / 2
                    e_y_avg = (e[2] + e[3]) / 2
                    ayat.append((e_x_avg, e_y_avg))
                extras = []

        y_avg = (actual_y_range[0] + actual_y_range[1]) / 2
        ayat.append(((x_range[1] + x_range[0]) / 2, y_avg))
        for e in extras:
            e_x_avg = (e[0] + e[1]) / 2
            e_y_avg = (e[2] + e[3]) / 2
            ayat.append((e_x_avg, e_y_avg))
        return process(ayat)

    img_gray = cv2.cvtColor(img_rgb, cv2.COLOR_BGR2GRAY)
    w, h = img_gray.shape
    template = cv2.resize(template, (int(w / 3), 50), interpolation=cv2.INTER_AREA)
    positions = find_basmala(img_gray, template)

    return positions


# input: img_rgb: cv2 image, template: cv2 image
# note: you must make the image transparent then black background
# note: you must make the header background black
def detect_headers(img_rgb, template):
    # heavily based on the "template matching" tutorial for opencv python

    def is_x_in_range(x_range, pt):
        if x_range[0] <= pt[0] <= x_range[1]:
            return True, False
        elif pt[0] >= x_range[0] and pt[0] - x_range[1] < 10:
            return True, True
        elif pt[0] <= x_range[1] and x_range[0] - pt[0] < 10:
            return True, True
        return False, False

    def is_y_in_range(y_range, pt):
        if y_range[0] <= pt[1] <= y_range[1]:
            return True, False
        elif pt[1] >= y_range[0] and pt[1] - y_range[1] < 10:
            return True, True
        elif pt[1] <= y_range[1] and y_range[1] - pt[1] < 10:
            return True, True
        return False, False

    def process(ayat):
        result = []
        cur_y = ayat[0][1]
        same_line = []
        for ayah in ayat:
            if abs(ayah[1] - cur_y) < 20:
                same_line.append(ayah)
            else:
                same_line.sort(key=lambda tup: tup[0])
                for s in same_line[::-1]:
                    result.append(s)
                cur_y = ayah[1]
                same_line = [ayah]

        same_line.sort(key=lambda tup: tup[0])
        for s in same_line[::-1]:
            result.append(s)
        return result

    def find_ayat(img_gray, template, threshold=0.6):
        w, h = template.shape[::-1]

        res = cv2.matchTemplate(img_gray, template, cv2.TM_CCOEFF_NORMED)
        loc = np.where(res >= threshold)

        points = list(zip(*loc[::-1]))
        ayat = []
        if len(points) == 0:
            return ayat

        extras = []
        x_range = (points[0][0], points[0][0])
        y_range = (points[0][1], points[0][1])
        actual_y_range = y_range

        for pt in points:
            x_in_range, should_expand_x = is_x_in_range(x_range, pt)
            y_in_range, should_expand_y = is_y_in_range(y_range, pt)

            if x_in_range and y_in_range:
                if should_expand_x:
                    x_range = (min(pt[0], x_range[0]), max(pt[0], x_range[1]))
                if should_expand_y:
                    y_range = (min(pt[1], y_range[0]), max(pt[1], y_range[1]))
                    actual_y_range = y_range
            elif y_in_range:
                # more than one ayah lives on this line
                added = False
                for i in range(0, len(extras)):
                    e = extras[i]
                    in_range, expand_x = is_x_in_range(e, pt)
                    if in_range:
                        if expand_x:
                            extras[i] = (min(e[0], pt[0]), max(pt[0], e[1]), e[2], e[3])
                        in_y_range, expand_y = is_y_in_range(e, pt)
                        if expand_y:
                            extras[i] = (e[0], e[1], min(e[2], pt[1]), max(e[3], pt[1]))
                        added = True
                        break
                if not added:
                    extras.append((pt[0], pt[0], pt[1], pt[1]))
                if should_expand_y:
                    y_range = (min(pt[1], y_range[0]), max(pt[1], y_range[1]))
            else:
                x_avg = (x_range[0] + x_range[1]) / 2
                y_avg = (actual_y_range[0] + actual_y_range[1]) / 2
                ayat.append((x_avg, y_avg))
                x_range = (pt[0], pt[0])
                y_range = (pt[1], pt[1])
                actual_y_range = y_range
                for e in extras:
                    e_x_avg = (e[0] + e[1]) / 2
                    e_y_avg = (e[2] + e[3]) / 2
                    ayat.append((e_x_avg, e_y_avg))
                extras = []

        y_avg = (actual_y_range[0] + actual_y_range[1]) / 2
        ayat.append(((x_range[1] + x_range[0]) / 2, y_avg))
        for e in extras:
            e_x_avg = (e[0] + e[1]) / 2
            e_y_avg = (e[2] + e[3]) / 2
            ayat.append((e_x_avg, e_y_avg))
        return process(ayat)

    img_gray = cv2.cvtColor(img_rgb, cv2.COLOR_BGR2GRAY)
    # resize template
    w, h = img_gray.shape[::-1]
    template = cv2.resize(template, (w, 56), interpolation=cv2.INTER_AREA)

    header_dims = find_ayat(img_gray, template)

    # this for margin the error for each header dim
    margin = 4

    new_dim = []

    for dim in header_dims:
        new_dim.append([dim[0], dim[1] + margin])
        new_dim.append([dim[0], dim[1] + 56 - margin])

    return new_dim


# input: img_rgb: cv2 image, template:cv2 image
# note: resize image by 50% of  the line height
def detect_aya(img_rgb, template):
    # heavily based on the "template matching" tutorial for opencv python

    def is_x_in_range(x_range, pt):
        if x_range[0] <= pt[0] <= x_range[1]:
            return True, False
        elif pt[0] >= x_range[0] and pt[0] - x_range[1] < 10:
            return True, True
        elif pt[0] <= x_range[1] and x_range[0] - pt[0] < 10:
            return True, True
        return False, False

    def is_y_in_range(y_range, pt):
        if y_range[0] <= pt[1] <= y_range[1]:
            return True, False
        elif pt[1] >= y_range[0] and pt[1] - y_range[1] < 10:
            return True, True
        elif pt[1] <= y_range[1] and y_range[1] - pt[1] < 10:
            return True, True
        return False, False

    def process(ayat):
        result = []
        cur_y = ayat[0][1]
        same_line = []
        for ayah in ayat:
            if abs(ayah[1] - cur_y) < 20:
                same_line.append(ayah)
            else:
                same_line.sort(key=lambda tup: tup[0])
                for s in same_line[::-1]:
                    result.append(s)
                cur_y = ayah[1]
                same_line = [ayah]

        same_line.sort(key=lambda tup: tup[0])
        for s in same_line[::-1]:
            result.append(s)
        return result

    def find_ayat(img_gray, template, threshold=0.5):

        res = cv2.matchTemplate(img_gray, template, cv2.TM_CCOEFF_NORMED)
        loc = np.where(res >= threshold)

        points = list(zip(*loc[::-1]))
        ayat = []
        if len(points) == 0:
            return ayat

        extras = []
        x_range = (points[0][0], points[0][0])
        y_range = (points[0][1], points[0][1])
        actual_y_range = y_range

        for pt in points:
            x_in_range, should_expand_x = is_x_in_range(x_range, pt)
            y_in_range, should_expand_y = is_y_in_range(y_range, pt)

            if x_in_range and y_in_range:
                if should_expand_x:
                    x_range = (min(pt[0], x_range[0]), max(pt[0], x_range[1]))
                if should_expand_y:
                    y_range = (min(pt[1], y_range[0]), max(pt[1], y_range[1]))
                    actual_y_range = y_range
            elif y_in_range:
                # more than one ayah lives on this line
                added = False
                for i in range(0, len(extras)):
                    e = extras[i]
                    in_range, expand_x = is_x_in_range(e, pt)
                    if in_range:
                        if expand_x:
                            extras[i] = (min(e[0], pt[0]), max(pt[0], e[1]), e[2], e[3])
                        in_y_range, expand_y = is_y_in_range(e, pt)
                        if expand_y:
                            extras[i] = (e[0], e[1], min(e[2], pt[1]), max(e[3], pt[1]))
                        added = True
                        break
                if not added:
                    extras.append((pt[0], pt[0], pt[1], pt[1]))
                if should_expand_y:
                    y_range = (min(pt[1], y_range[0]), max(pt[1], y_range[1]))
            else:
                x_avg = (x_range[0] + x_range[1]) / 2
                y_avg = (actual_y_range[0] + actual_y_range[1]) / 2
                ayat.append((x_avg, y_avg))
                x_range = (pt[0], pt[0])
                y_range = (pt[1], pt[1])
                actual_y_range = y_range
                for e in extras:
                    e_x_avg = (e[0] + e[1]) / 2
                    e_y_avg = (e[2] + e[3]) / 2
                    ayat.append((e_x_avg, e_y_avg))
                extras = []

        y_avg = (actual_y_range[0] + actual_y_range[1]) / 2
        ayat.append(((x_range[1] + x_range[0]) / 2, y_avg))
        for e in extras:
            e_x_avg = (e[0] + e[1]) / 2
            e_y_avg = (e[2] + e[3]) / 2
            ayat.append((e_x_avg, e_y_avg))
        return process(ayat)

    img_gray = cv2.cvtColor(img_rgb, cv2.COLOR_BGR2GRAY)
    template = cv2.cvtColor(template, cv2.COLOR_BGR2GRAY)
    return find_ayat(img_gray, template)


# input: image: PIL image, template header frame : PIL image
def detect_lines(image, template):
    """
    algorithm for determining rows
    - find out the number of non-white pixels in each row
    - rows with low pixel count (20 and below, for example) are break points
    - combine them into ranges, such that we have line+1 groups
    - if midpoint[i+1] - height is within range, use it - otherwise, start at
      either low[i] and end at low[i] + height or at high[i] and end after height
      depending on where we are relative to the range at i

    then, for each line's ys, find the min x and max across them.
    we then have the bounding box for each line
    """

    def is_not_blank(pt):
        return sum(pt) < 200 * len(pt)

    def find_lines(image, line_height, max_pixels, mode):
        ranges = []
        range_end = -1
        range_start = -1
        restrict_lines = True
        if mode == 1:
            restrict_lines = False

        data = image.getdata()
        width, height = image.size
        for y in range(0, height):
            filled_pixels = 0
            for x in range(0, width):
                pt = data[y * width + x]
                if is_not_blank(pt):
                    filled_pixels = filled_pixels + 1
            # print("line " + str(y) + " has " + str(filled_pixels))
            if filled_pixels < max_pixels:
                if range_start == -1:
                    if restrict_lines and filled_pixels == 0 and len(ranges) == 0:
                        continue
                    range_start = y
                    range_end = y
                elif y - range_end < 20:
                    range_end = y
                else:
                    # print "adding range " + str(range_start) + "," + str(range_end)
                    ranges.append((range_start, range_end))
                    range_start = -1
                    range_end = -1
        if range_start > -1:
            ranges.append((range_start, range_end))

        line_ys = []
        should_skip = False
        for i in range(0, len(ranges) - 1):
            if should_skip:
                should_skip = False
                continue
            top = ranges[i]
            bottom = ranges[i + 1]
            midpoint = (bottom[0] + bottom[1]) / 2

            if bottom[1] - top[0] < line_height:
                top_midpoint = ((top[0] + top[1]) / 2)
                top = (top_midpoint, midpoint)
                bottom = ranges[i + 2]
                midpoint = (bottom[0] + bottom[1]) / 2
                should_skip = True

            top_y = midpoint - line_height
            if top[0] <= top_y <= top[1]:
                # within range, we keep it
                line_ys.append((top_y, midpoint))
            elif top_y < top[0]:
                if top[0] + line_height < height:
                    line_ys.append((top[0], top[0] + line_height))
            else:
                if top[1] + line_height < height:
                    line_ys.append((top[1], top[1] + line_height))

        lines = []
        for yrange in line_ys:
            first_x = width
            last_x = 0
            for y in range(int(yrange[0]), int(yrange[1])):
                for x in range(0, width):
                    pt = data[y * width + x]
                    if is_not_blank(pt):
                        if first_x > x:
                            first_x = x - 1
                        break
                for x in reversed(range(0, width)):
                    pt = data[y * width + x]
                    if is_not_blank(pt):
                        if x > last_x:
                            last_x = x
                        break
            lines.append(((first_x, yrange[0]), (last_x, yrange[1])))
        return lines

    # headers_dim = detect_headers(image, template)
    W, H = image.size[0], image.size[1]
    lines = find_lines(image, 57, 5, 0)

    def draw(image, lines, output):
        drawing = ImageDraw.Draw(image)
        for line in lines:
            drawing.rectangle([line[0], line[1]], None, (255, 0, 0))
        del drawing
        image.save(output)

    draw(image, lines, 'lines.png')
    return lines
    # new_lines = []
    # for line in lines:
    #     f = True
    #     for start, end in headers_dim:
    #         if start[1] <= line[0][1] <= end[1] or start[1] <= line[1][1] <= end[1]:
    #             f = False
    #             break
    #     if f:
    #         new_lines.append(line)
    #
    # return new_lines


# input: take Ai image path
# output: return PIL image
def AI2PNG(img):
    return convert_from_path(img, size=(912, 1012))[0]
