del epub.epub
"C:\Program Files\7-Zip\7z.exe" a -tzip "epub.epub" mimetype -mx=0
"C:\Program Files\7-Zip\7z.exe" u -tzip "epub.epub" "OEBPS" -r -x!mimetype
"C:\Program Files\7-Zip\7z.exe" u -tzip "epub.epub" "META-INF" -r -x!mimetype