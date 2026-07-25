# Quran Widget Flutter
## Description
#### Package to get Narrations, Books, Chapters,Recitations for Favorite Reciters and View Quran Pages with bast View

## Getting Started

## setup your app
#### Add lib in Your Project 
    dependencies:
        quran_widget_flutter:<Last Version>
#### First visit our Web Site  and get client Id and client Secret than Call 
    DataSource.initialApp(clientId: {Your client Id}, clientSecret: {Your client Secret}) 
#### You Can Access Method DataSource
    DataSource.instance.{method Name}
#### Method in DataSource
##### Fetch Narrations
    DataSource.instance.fetchNarrationsList(qurey: {Your Search key Word})
###### this Method get all Narrations or Send value to search on Narrations by it 
    DataSource.instance.fetchNarrationById({Your Narration Id})
###### this Method get One Narration Have id you send to it
##### Fetch Books
    DataSource.instance.fetchBooksList(qurey: {Your Search key Word},narrationId:{Narration Id})
###### this Method get all Books or Send value to search on Books by it or Filter Books by Narration
    DataSource.instance.fetchBookById({Your Book Id})
###### this Method get One Book Have id you send to it
##### Fetch Chapters
    DataSource.instance.fetchChaptersList(qurey: {Your Search key Word},narrationId:{Narration Id})
###### this Method get all Chapters or Send value to search on Chapters by it 
    DataSource.instance.fetchChapterById({Your Chapter Id})
###### this Method get One Chapter Have id you send to it
##### Fetch Parts
    DataSource.instance.fetchPartsList(qurey: {Your Search key Word})
###### this Method get all Parts of Quran or Send value to search on Parts by it 
    DataSource.instance.fetchPartById({Your Part Id})
###### this Method get One Part Have id you send to it
##### Fetch Pages
    DataSource.instance.fetchPagesList(qurey: {Your Search key Word})
###### this Method get all Pages or Send value to Pages on Pages by it 
    DataSource.instance.fetchPageById({Your Page Id})
###### this Method get One Page Have id you send to it
##### Fetch Reciters
    DataSource.instance.fetchRecitersList(qurey: {Your Search key Word})
###### this Method get all Reciters or Send value to search on Reciters by it 
    DataSource.instance.fetchReciterById({Your Reciter Id})
###### this Method get One Reciter Have id you send to it
##### Fetch Recitations
    DataSource.instance.fetchRecitationsList(qurey: {Your Search key Word})
###### this Method get all Recitations or Send value to search on Recitations by it 
    DataSource.instance.fetchRecitationById({Your Recitation Id})
###### this Method get One Recitation Have id you send to it
##### Fetch Recitations Verses
    DataSource.instance.fetchRecitationsVersesList({Your Recitation Id})
###### this Method get all Recitations for every Verse for Reciter 
    DataSource.instance.fetchRecitationVersesById({Your Recitation Id},{Your Recitation Verses Id})
###### this Method get One Recitation Have id you send to it

#### Data Models 
###### Narration
    Narration({
        id,
        name,
        description,
    });

###### Book
    Book({
        id,
        name,
        narrationId,
    });

###### Chapter
    Chapter({
        id,
        name,
    });

###### Part
     Part({
        id,
        name,
        alias,
        partNumber,
    });

###### Page
    Page({
        id,
        pageNumber,
        narrationId,
        chapterId,
        bookId,
        partId,
        subPartId,
        image,
        verses,
        glyphs,
    });

###### Reciter
    Reciter({
        id,
        name,
    });

###### Recitation
    Recitation({
        id,
        narrationId,
        reciterId,
    });

###### Recitation Verses
    RecitationVerses({
        id,
        verseId,
        verseNumber,
        recitationId,
        record, link of recode of this verse
    });

###### Verse
    Verse({
        id,
        text,
        uthmanicText,  // the verse by uthmanic-Font
        lineStart,  // lineStart and lineEnd lines the verse on page 
        lineEnd,
        image, image of this verse
        narrationId,
        chapterId,
        bookId,
        partId,
        pageId,
    });

###### Glyph
    Glyph({
        id,
        verseId,
        pageId,
        chapterId, 
        lineNumber,
        position,
        minX, // this points is prcents of size image to drow border on selected verse by those points
        maxX,
        minY,
        maxY,
    });
      
