import cv2
from PIL import Image
import zipfile

from apps.quran.models import BookImageUpload, BookPattern
from apps.quran.models import Glyph

hafs_ayat = [7, 286, 200, 176, 120, 165, 206, 75, 129, 109, 123, 111,
             43, 52, 99, 128, 111, 110, 98, 135, 112, 78, 118, 64, 77,
             227, 93, 88, 69, 60, 34, 30, 73, 54, 45, 83, 182, 88, 75,
             85, 54, 53, 89, 59, 37, 35, 38, 29, 18, 45, 60, 49, 62, 55,
             78, 96, 29, 22, 24, 13, 14, 11, 11, 18, 12, 12, 30, 52, 52,
             44, 28, 28, 20, 56, 40, 31, 50, 40, 46, 42, 29, 19, 36, 25,
             22, 17, 19, 26, 30, 20, 15, 21, 11, 8, 8, 19, 5, 8, 8, 11,
             11, 8, 3, 9, 5, 4, 7, 3, 6, 3, 5, 4, 5, 6]

warsh_ayat = [7, 285, 200, 175, 122, 167, 206, 76, 130, 109, 121, 111,
              44, 54, 99, 128, 110, 105, 99, 134, 111, 76, 119, 62, 77,
              226, 95, 88, 69, 59, 33, 30, 73, 54, 46, 82, 182, 86, 72,
              84, 53, 50, 89, 56, 36, 34, 39, 29, 18, 45, 60, 47, 61, 55,
              77, 99, 28, 21, 24, 13, 14, 11, 11, 18, 12, 12, 31, 52, 52,
              44, 30, 28, 18, 55, 39, 31, 50, 40, 45, 42, 29, 19, 36, 25,
              22, 17, 19, 26, 32, 20, 15, 21, 11, 8, 8, 20, 5, 8, 9, 11,
              10, 8, 3, 9, 5, 5, 6, 3, 6, 3, 5, 4, 5, 6]

sura = 112  # number of sura that you want to start
ayah = 1
# number of lines to skip when the end of the sura is reached
# for example, one for the basmallah and one for the header.
# 1 is automatically deducted from this number for sura Tawbah.
default_lines_to_skip = 2
sura_ayat = hafs_ayat  # todo: change this to narrations type

# by default, we don't increase the ayah on the top of this loop
# to handle ayat that span multiple pages - this flag allows us to
# override this.
end_of_ayah = True


def process_ayat(ayat):
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
    print(result)
    return result


def process_book_images(pk, line_height):
    def draw(img_rgb, template, ayat, output):
        w, h = template.shape[0], template.shape[1]
        for point in ayat:
            pt = (int(point[0]), int(point[1]))
            cv2.rectangle(img_rgb, pt, (pt[0] + w, pt[1] + h), (0, 0, 255), thickness=2)
        cv2.imwrite(output, img_rgb)

    def read_zip_files(zipfilepath):
        # Read in zip file
        zip = zipfile.ZipFile(zipfilepath)

        file_names = []
        # Iterate through files in zip file
        for zipfilename in zip.filelist:
            # Read contents of the file
            file_names.append(zipfilename.filename)

        # uncompress the files
        image_dir = "/".join(book_image_upload.file.path.split('/')[:-1]) + '/images/'
        with zipfile.ZipFile(book_image_upload.file.path, "r") as zip_ref:
            zip_ref.extractall(image_dir)

        return file_names, image_dir


    def remove_frame(img_rgb, template):
        img_gray = cv2.cvtColor(img_rgb, cv2.COLOR_BGR2GRAY)
        w, h = template.shape[::-1]
        img = img_gray.copy()
        res = cv2.matchTemplate(img, template, cv2.TM_CCOEFF)
        min_val, max_val, min_loc, max_loc = cv2.minMaxLoc(res)
        top_left = max_loc

        bottom_right = (top_left[0] + w, top_left[1] + h)

        border_width = 40
        padding = 7
        # inner_width = 518
        # line_height = 56
        outer_frame = border_width + padding
        inner_top_left = (top_left[0] + outer_frame, top_left[1] + outer_frame)
        inner_bottom_right = (bottom_right[0] - outer_frame, bottom_right[1] - outer_frame)
        cv2.rectangle(img, inner_top_left, inner_bottom_right, 0, 5)

        return img_rgb[inner_top_left[1]:inner_bottom_right[1], inner_top_left[0]:inner_bottom_right[0]]

    def create_glyph(verse, lines, current_line, page, lines_to_skip=2, x_pos_in_line=-1):
        first = False
        y_pos_of_verse = verse[1]
        pos = 0
        glyphs = []
        chapter = page.chapter
        for line in range(current_line, num_lines):
            # skip header and basmala lines
            if lines_to_skip > 0:
                lines_to_skip = lines_to_skip - 1
                current_line = current_line + 1
                continue

            pos = pos + 1
            cur_line = lines[line]
            miny = cur_line[0][1]
            maxy = cur_line[1][1]

            if y_pos_of_verse <= maxy:
                # we found the line with the ayah
                maxx = cur_line[1][0]
                if x_pos_in_line > 0:
                    maxx = x_pos_in_line
                minx = verse[0]
                glyphs.append(Glyph(line_number=line + 1, position=pos, min_x=minx,
                                    max_x=maxx, min_y=miny, max_y=maxy, page=page, chapter=chapter))

            end_of_sura = False
            if sura_ayat[sura - 1] == ayah:
                end_of_sura = True

            if end_of_sura:
                x_pos_in_line = -1
                current_line = current_line + 1
                if current_line == num_lines:
                    # last line, and no more ayahs - set it to increase
                    end_of_ayah = True
            else:
                x_pos_in_line = minx
            break
        else:
            # we add this line
            maxx = cur_line[1][0]
            if x_pos_in_line > 0:
                maxx = x_pos_in_line
            x_pos_in_line = -1
            current_line = current_line + 1

            glyphs.append([i, line + 1, sura, ayah, pos, cur_line[0][0], maxx,
                           cur_line[0][1], cur_line[1][1]])

            # save the data in database
            # todo: add page, verses relation
            Glyph.objects.create(line_number=line + 1, position=pos, min_x=cur_line[0][0],
                                 max_x=maxx, min_y=cur_line[0][1], max_y=cur_line[1][1])

    # get instances
    book_image_upload = BookImageUpload.objects.get(pk=pk)
    book = book_image_upload.book
    book_length = 604  # todo: get this from book table
    zipfilepath = book_image_upload.file.path
    frame = cv2.imread(BookPattern.objects.get(type='frame').file.path, 0)
    file_names, image_dir = read_zip_files(zipfilepath)
    pages = book.book_page.all().order_by('page_number')

    # for filename in os.listdir(image_dir):
    #     file_path = os.path.join(image_dir, filename)
    #     page = pages.filter(page_number=int(filename[:3])).first()
    #     verses = page.pages_verse.all()
    #
    #     image = Image.open(file_path)
    #     process_page(image, page, verses)

    """
        constrains
    """
    end_of_ayah = True
    default_lines_to_skip = 2

    for page_number in range(3, book_length):
        filename = str(page_number).zfill(3) + '___Hafs39__DM.jpg'
        if filename in file_names:
            image = Image.open(image_dir + filename).convert('RGBA')
            verses, lines = process_page(image)
            num_lines = len(lines)
            first = True
            end_of_sura = False
            current_line = 0
            glyphs = []
            page = pages.get(page_number=page_number)
            for verse in verses:
                glyphs.append(create_glyph(verse=verse, lines=lines, current_line=current_line, page=page))
            Glyph.objects.bulk_create(glyphs)
