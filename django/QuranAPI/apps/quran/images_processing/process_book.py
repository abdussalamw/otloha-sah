import zipfile

import cv2
from PIL import Image
from django.core.files.base import ContentFile

from apps.chapters.models import Chapter
from apps.quran.images_processing import images
from apps.quran.models import BookPattern, Book, Page, Glyph


def draw(img_rgb, template, verses):
    template = cv2.imread(template.file.path, 0)
    w, h = template.shape[0], template.shape[1]
    for point in verses:
        pt = (int(point[0]), int(point[1]))
        cv2.rectangle(img_rgb, pt, (pt[0] + w, pt[1] + h), (0, 0, 255), thickness=1)
    # cv2.imwrite(output, img_rgb)


def draw_marker(img_rgb, template, verses):
    template = cv2.imread(template, 0)
    template = cv2.resize(template, (30, 30))
    # img_rgb = cv2.imread(img_rgb)
    w, h = template.shape[::-1]
    for point in verses:
        pt = (int(point[0]), int(point[1]))
        cv2.rectangle(img_rgb, pt, (int(pt[0] + w), int(pt[1] + h)), (0, 0, 255), thickness=1)
    # cv2.imwrite(output, img_rgb)


class ProcessBookImages:
    book: Book = None
    pages: Page = None
    # file: BookImageUpload = None
    files = []
    uncompressed_files_dir = None
    patterns = None
    frame_pattern = None
    marker = None

    def set_book(self):
        self.book = self.file.book

    def set_file(self, file_pk):
        pass
        # self.file = BookImageUpload.objects.get(pk=file_pk)

    def get_book_images_patterns(self):
        self.patterns = BookPattern.objects.filter(book_images_uploads=self.file)

    def get_frame_pattern(self):
        self.frame_pattern = self.patterns.get(type="frame")

    def get_verse_marker_pattern(self):
        self.marker = self.patterns.get(type="marker")

    def initialize_book(self, book_file_id):
        self.set_file(book_file_id)
        self.set_book()
        self.get_book_images_patterns()
        self.get_frame_pattern()
        self.get_verse_marker_pattern()
        self.get_pages()

    def get_pages(self):
        self.pages = self.book.book_page.all().order_by('page_number')

    def read_zip_files(self):
        file_path = self.file.file.path

        for zipfile_name in zipfile.ZipFile(file_path).filelist:
            self.files.append(zipfile_name.filename)

        self.uncompressed_files_dir = "/".join(file_path.split('/')[:-1]) + '/images/'
        with zipfile.ZipFile(file_path, "r") as zip_ref:
            zip_ref.extractall(self.uncompressed_files_dir)

    def resolve_filename(self, page_number):
        return str(page_number).zfill(3) + '___Hafs39__DM.jpg'

    # TODO add book_length to book_file model
    def x(self, book_length=605):
        glyphs = []
        for page_number in range(603, book_length):
            filename = self.resolve_filename(page_number)
            if filename in self.files:
                image = Image.open(self.uncompressed_files_dir + filename).convert('RGBA')

                page = self.pages.get(page_number=page_number)
                db_verses = page.pages_verse.all().order_by("chapter__chapter_number", "verse_number")
                verses_in_lines = {}
                # for db_verse in db_verses:
                #     verses_in_lines.setdefault(db_verse.verse_number, set()).add(db_verse.line_start)

                for db_verse in db_verses:
                    if verses_in_lines.get(db_verse.line_start, None):
                        verses_in_lines[db_verse.line_start] += 1
                    else:
                        verses_in_lines[db_verse.line_start] = 1
                # print(verses_in_lines)
                # TODO Delete
                db_chapters_ids = db_verses.values_list('chapter', flat=True)
                db_chapters = Chapter.objects.filter(pk__in=db_chapters_ids)

                db_lines = list({*db_verses.values_list('line_start', flat=True),
                                 *db_verses.values_list('line_end', flat=True)})

                markers, lines, image = images.process_page(
                    image=image,
                    frame=self.frame_pattern,
                    marker=self.marker,
                )

                _, file_image = cv2.imencode('.jpg', image)
                file_image = ContentFile(file_image)
                page.image.save('image.jpg', file_image, save=True)

                verse_index = 0
                marker_pos_x = -1
                current_line_index = 0
                for marker in markers:
                    marker_pos_y = marker[1]
                    glyph_position_in_verse = 0
                    for line in range(current_line_index, len(lines)):
                        if line + 1 in db_lines:

                            verse = db_verses[verse_index]

                            chapter_verse_count = db_chapters.get(pk=verse.chapter_id).chapter_verse.count()

                            glyph_position_in_verse += 1
                            current_line = lines[line]
                            min_y = current_line[0][1]
                            max_y = current_line[1][1]

                            max_x = current_line[1][0]
                            if marker_pos_x > 0:
                                max_x = marker_pos_x

                            if marker_pos_y <= max_y:

                                min_x = marker[0]

                                glyph = {
                                    "page": page,
                                    "chapter": verse.chapter,
                                    "verses": verse,
                                    "line_number": (current_line_index + 1),
                                    "position": glyph_position_in_verse,
                                    "min_x": min_x,
                                    "min_y": min_y,
                                    "max_x": max_x,
                                    "max_y": max_y
                                }
                                last = (max_x, max_y)
                                glyphs.append(Glyph(**glyph))

                                verse_index += 1

                                if verse.verse_number >= chapter_verse_count or abs(min_x - current_line[0][0]) < (
                                        marker[1] / 2):
                                    marker_pos_x = -1
                                    current_line_index += 1
                                else:
                                    marker_pos_x = min_x

                                break
                            elif last:
                                x, y = last[0], last[1]
                                marker_pos_x = -1
                                current_line_index = (current_line_index + 1)

                                # print("else", verses.verse_number, verses.chapter.chapter_number)
                                min_x = last[1]
                                min_y = last[0]
                                max_y = current_line[1][1]
                                glyph = {
                                    "page": page,
                                    "chapter": verse.chapter,
                                    "verses": verse,
                                    "line_number": (current_line_index + 1),
                                    "position": glyph_position_in_verse,
                                    "min_x": min_x,
                                    "min_y": min_y,
                                    "max_x": max_x,
                                    "max_y": max_y
                                }
                                glyphs.append(Glyph(**glyph))

        return glyphs

    def process_files(self, book_length=605):
        glyphs = []
        for page_number in range(604, book_length):
            filename = self.resolve_filename(page_number)
            if filename in self.files:
                image = Image.open(self.uncompressed_files_dir + filename).convert('RGBA')
                page = self.pages.get(page_number=page_number)
                db_verses = page.pages_verse.all().order_by("chapter__chapter_number", "verse_number")
                print(db_verses.values_list('verse_number', flat=True))
                # TODO Delete
                db_chapters_ids = db_verses.values_list('chapter', flat=True)
                db_chapters = Chapter.objects.filter(pk__in=db_chapters_ids)

                # db_lines = list({*db_verses.values_list('line_start', flat=True),
                #                  *db_verses.values_list('line_end', flat=True)})
                db_lines = []
                for db_verse in db_verses:
                    for i in range(db_verse.line_start, db_verse.line_end + 1):
                        db_lines.append(i)
                db_lines = set(db_lines)

                markers, lines, image = images.process_page(
                    image=image,
                    frame=self.frame_pattern,
                    marker=self.marker,
                )

                _, file_image = cv2.imencode('.jpg', image)
                file_image = ContentFile(file_image)
                page.image.save('image.jpg', file_image, save=True)
                # img_copy = image.copy()
                # draw_marker(img_copy, self.marker.file.path, markers)
                # for line in lines:
                #     start_point = (int(line[0][0]), int(line[0][1]))
                #     end_point = (int(line[1][0]), int(line[1][1]))
                #     cv2.rectangle(img_copy, start_point, end_point, (233, 23, 32), 2)
                # cv2.imwrite("both.jpg", img_copy)

                lines_markers = {}
                for index, line in enumerate(lines):
                    lines_markers[index] = []
                    if index + 1 in list(db_lines):
                        for marker in markers:
                            # TODO check equals
                            if line[0][1] < marker[1] < line[1][1]:
                                lines_markers[index].append(marker)

                # TODO delete
                # img_copy = image.copy()
                verse_index = 0
                for line, line_markers in lines_markers.items():
                    # chapter_length = verses.chapter.chapter_verse.count()
                    if len(line_markers):
                        """ To Handle Lines With Markers """
                        end_point = None
                        for marker_index, line_marker in enumerate(line_markers):
                            verse = db_verses[verse_index]
                            start_point = (int(line_marker[0]), int(lines[line][0][1]))
                            if not end_point:
                                end_point = (int(lines[line][1][0]), int(lines[line][1][1]))
                            print("ls", start_point[0])
                            glyphs.append(Glyph(**{
                                "page": page,
                                "chapter": verse.chapter,
                                "verse_id": verse.id,
                                "line_number": (line + 1),
                                "min_x": start_point[0],
                                "min_y": start_point[1],
                                "max_x": end_point[0],
                                "max_y": end_point[1]
                            }))

                            verse_index += 1
                            # TODO Glyph
                            # cv2.rectangle(img_copy, start_point, end_point, (233, 23, 32), 2)
                            # cv2.imwrite("res_{}_{}.jpg".format(line, marker_index), img_copy)
                            # TODO end Remove

                            end_point = (int(line_marker[0]), int(lines[line][1][1]))

                            # handle end of the line
                            if end_point[0] > lines[line][0][0] and marker_index == len(line_markers) - 1:
                                print("minx else", lines[line][0][0])
                                glyphs.append(Glyph(**{
                                    "page": page,
                                    "chapter": verse.chapter,
                                    "verse_id": verse.id,
                                    "line_number": (line + 1),
                                    "min_x": lines[line][0][0],
                                    "min_y": lines[line][0][1],
                                    "max_x": end_point[0],
                                    "max_y": end_point[1]
                                }))
                            # TODO delete
                            # cv2.rectangle(img_copy, (int(lines[line][0][0]), int(lines[line][0][1])), end_point,
                            #               (233, 23, 32), 2)
                            # cv2.imwrite("res_{}_{}.jpg".format(line, marker_index), img_copy)
                            # TODO end delete

                    elif line + 1 in db_lines:
                        """ To Handle Lines Without Markers """
                        verse = db_verses[verse_index]
                        start_point = (int(lines[line][0][0]), int(lines[line][0][1]))
                        end_point = (int(lines[line][1][0]), int(lines[line][1][1]))
                        # print( start_point[0])
                        glyphs.append(Glyph(**{
                            "page": page,
                            "chapter": verse.chapter,
                            "verse_id": verse.id,
                            "line_number": (line + 1),
                            "min_x": start_point[0],
                            "min_y": start_point[1],
                            "max_x": end_point[0],
                            "max_y": end_point[1]
                        }))

                        # TODO Remove
                        # cv2.rectangle(img_copy, start_point, end_point, (233, 23, 32), 2)
                        # cv2.imwrite("res_{}_{}.jpg".format(line, line), img_copy)
                        # TODO end Remove
        return glyphs

    def execute(self, book_file_id):
        self.initialize_book(book_file_id)
        self.read_zip_files()
        # self.process_files()
        Glyph.objects.bulk_create(self.process_files())

        # for page in Page.objects.filter(book=self.book).order_by('page_number'):
        #     image = cv2.imread(page.image.path)
        #     glyphs = page.page_glyph.order_by('verse__verse_number')
        #     for glyph in glyphs:
        #         start_point = (glyph.min_x, glyph.min_y)
        #         end_point = (glyph.max_x, glyph.max_y)
        #         cv2.rectangle(image, start_point, end_point, (233, 23, 32), 2)
        #
        #     cv2.imwrite('res_{}.jpg'.format(page.page_number), image)
