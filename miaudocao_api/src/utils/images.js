const sharp = require('sharp');

async function compressImage(image) {
  const parts = image.split(';');
  const imageData = parts[1].split(',')[1];
  const img = new Buffer.from(imageData, 'base64');
  const buffer = await sharp(img)
    .resize({
      fit: sharp.fit.contain,
      width: 1000
    })
    .toFormat('jpg')
    .toBuffer();
  const resizedImageData = buffer.toString('base64');
  const resizedImage = `data:image/jpg;base64,${resizedImageData}`;

  return resizedImage;
}

module.exports = {
  compressImage
}