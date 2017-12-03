# EpubResourceTEP
「[倫理と哲学のトピック](https://www.amazon.co.jp/dp/B077G3J5TJ)」のepubを作成する為作ったツール他。

拙著です。ぜひ読んでください。

## calc
epubの操作をいろいろしたついでにEpubでJavaScriptなしに電卓を作ってみました。

releaseからダウンロードできます。

## facebook
facebookのバックアップ機能を使って、いろいろやりながらepubにします。

[「2017年投稿履歴」](https://www.amazon.co.jp/dp/B07859JMHN)の作成に使いました。

手順は基本的に``perl split.pl << timeline.htm``の後seiton.plを一から順番に。最後にjoinf.plとmake_*.plで足りないファイルはSigilとかから補完。
