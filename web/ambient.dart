import 'dart:html';

void main() {
  Element imagesContainer = document.querySelector('#images');
  List<String> images = ['images/cat_bw.jpg', 'images/milky_way.jpg', 'images/mochi.jpg', 'images/shanghai.jpg', 'images/tulips.jpg'];
  images.forEach((url) => imagesContainer.append(loadImage(url)));

  document.querySelector('#load-flickr').onClick.listen(onLoadFlickr);
}

ImageElement loadImage(String imageUrl) {
  ImageElement img = new ImageElement();
  img
      ..src = imageUrl
      ..onLoad.listen(onImageLoaded);
  return img;
}

void onImageLoaded(Event event) {
  DateTime start = new DateTime.now();
  ImageElement img = event.target;
  ImageData imageData = getImageData(img);
  int r = 0;
  int g = 0;
  int b = 0;
  int a = 0;

  for (var row = 0; row < img.height; row++) {
    int indexOfFirstPixelInRow = 4 * img.width * row;
    for (var col = 0; col < img.width; col++) {
      int indexOfFirstByteInPixel = indexOfFirstPixelInRow + col * 4;
      r += imageData.data[indexOfFirstByteInPixel];
      g += imageData.data[indexOfFirstByteInPixel + 1];
      b += imageData.data[indexOfFirstByteInPixel + 2];
      a += imageData.data[indexOfFirstByteInPixel + 3];
    }
  }

  int totalPixels = imageData.data.length ~/ 4;
  r ~/= totalPixels;
  g ~/= totalPixels;
  b ~/= totalPixels;
  a ~/= totalPixels;
  double alpha = a / 255;
  img.style.borderColor = "rgba($r, $g, $b, $alpha)";
  img.title = "Ambient color is rgba($r, $g, $b, $alpha)";
  DateTime end = new DateTime.now();
  LIElement logEntry = new LIElement();
  logEntry.text = "Done in ${end.difference(start).inMilliseconds} ms. ${img.src}";
  document.querySelector("#log").append(logEntry);
}

ImageData getImageData(ImageElement img) {
  CanvasElement canvas = new CanvasElement();
  canvas
      ..width = img.width
      ..height = img.height;
  CanvasRenderingContext2D context = canvas.context2D;
  context.drawImage(img, 0, 0);
  ImageData imageData = context.getImageData(0, 0, img.width, img.height);
  return imageData;
}

void onLoadFlickr(MouseEvent event) {
  
}
