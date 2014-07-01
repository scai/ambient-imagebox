import 'dart:html';

void main() {
  document.querySelectorAll("img").onClick.listen(onClick);
}

void onClick(MouseEvent event) {
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
  document.querySelector("#log").text = "Done in ${end.difference(start).inMilliseconds} ms.";
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
