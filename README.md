# Plane_bothSideTexture #

## 環境 ##
*	OS X El Capitan(10.11.6)
*	Xcode : 7.2
*	unity : 5.3.0f4

## add on ##

## Contents ##
planeで両面共にtextureを表示するためのshader(通常は、片面が透明になってしまう).  
oF syphonで透過なimageを受けてこれを表示する動作も、確認ok.  

参考URL  
http://nn-hokuson.hatenablog.com/entry/2017/03/03/202309  

## Device ##

## note ##
確認の結果、透明なtextureを張った際、輪郭が見えてしまう問題を発見した。
よって、両面にtextureを貼る場合、planeではなく、Cubeにして、厚みをzeroにすることとする.





