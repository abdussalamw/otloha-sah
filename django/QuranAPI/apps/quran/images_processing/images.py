import cv2
import numpy
from PIL import Image

from apps.quran.images_processing import lines as ln
from apps.quran.images_processing import verses as ver


#
# def remove_frame(img_rgb, template):
#     img_gray = cv2.cvtColor(img_rgb, cv2.COLOR_BGR2GRAY)
#     template = cv2.resize(template, (int(img_gray.shape[1]), int(img_gray.shape[0] - (img_gray.shape[0] * 0.07))),
#                           interpolation=cv2.INTER_AREA)
#
#     w, h = template.shape[::-1]
#     methods = ['cv2.TM_CCOEFF', 'cv2.TM_CCOEFF_NORMED', 'cv2.TM_CCORR_NORMED', 'cv2.TM_SQDIFF', 'cv2.TM_SQDIFF_NORMED']
#
#     for meth in methods:
#         img = img_gray.copy()
#         method = eval(meth)
#         res = cv2.matchTemplate(img, template, method)
#         min_val, max_val, min_loc, max_loc = cv2.minMaxLoc(res)
#
#         # If the method is TM_SQDIFF or TM_SQDIFF_NORMED, take minimum
#         if method in [cv2.TM_SQDIFF, cv2.TM_SQDIFF_NORMED]:
#             top_left = min_loc
#         else:
#             top_left = max_loc
#         bottom_right = (top_left[0] + w, top_left[1] + h)
#
#         border_width = 40
#         padding = 7
#         inner_width = 518
#         line_height = 56
#         outer_frame = border_width + padding
#         inner_top_left = (top_left[0] + outer_frame, top_left[1] + outer_frame)
#         inner_bottom_right = (bottom_right[0] - outer_frame, bottom_right[1] - outer_frame)
#
#         return img_rgb[inner_top_left[1]:inner_bottom_right[1], inner_top_left[0]:inner_bottom_right[0]]
#


def remove_frame(img_rgb, template):
    img_gray = cv2.cvtColor(img_rgb, cv2.COLOR_BGR2GRAY)
    w, h = template.shape[1], template.shape[0]

    img = img_gray.copy()
    res = cv2.matchTemplate(img, template, cv2.TM_CCOEFF_NORMED)
    min_val, max_val, min_loc, max_loc = cv2.minMaxLoc(res)

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


def make_white_bg(img):
    img = img.convert('RGBA')
    bg = Image.new(img.mode, img.size, (255, 255, 255, 1))
    i = Image.alpha_composite(bg, img)
    return i


def process_page(image, frame, marker):
    image_white_bg = image.copy()
    image_white_bg = make_white_bg(image_white_bg)
    image_cv = numpy.array(image_white_bg)

    frame = cv2.imread(frame.file.path, 0)
    cropped = remove_frame(image_cv, frame)

    image_crop = Image.fromarray(cropped).convert('RGBA')
    lines = ln.detect_lines(image_crop)

    marker = cv2.imread(marker.file.path, 0)
    marker = cv2.resize(marker, (32, 32))
    cv2.imwrite('marker.png', marker)
    verses = ver.detect_aya(cropped, marker)
    return verses, lines, cropped
#
