# Barcode Extraction Minimal API

A .NET 8 minimal API that extracts barcode regions from JPG images and returns the smallest possible JPG containing just the barcode.

## Features

- ✅ Accepts JPG image uploads via multipart/form-data
- ✅ Detects barcodes using ZXing library
- ✅ Extracts the smallest region containing the barcode
- ✅ Adds intelligent padding around barcode
- ✅ Returns optimized JPG (85% quality for file size)
- ✅ CORS enabled for cross-origin requests
- ✅ OpenAPI/Swagger documentation included

## Prerequisites

- .NET 8.0 SDK or later
- Visual Studio Code or Visual Studio 2022 (recommended)

## Getting Started

### 1. Clone and Setup
```bash
git clone <repo-url>
cd BarcodeApi
dotnet restore
```

### 2. Run the API
```bash
dotnet run
```

The API will start on `https://localhost:5001` (HTTPS) and `http://localhost:5000` (HTTP)

### 3. Access OpenAPI Documentation
Visit: `https://localhost:5001/swagger` or `http://localhost:5000/swagger`

## API Endpoint

### POST /extract-barcode

**Description:** Extracts barcode from an uploaded JPG image

**Request:**
- Content-Type: `multipart/form-data`
- Form field: `image` (file, JPG format)

**Response:**
- Success (200): Returns a JPG image containing only the barcode region
- Bad Request (400): Invalid input
- Not Found (404): No barcode detected
- Server Error (500): Processing error

### Example Usage

**Using curl:**
```bash
curl -X POST \
  -F "image=@photo.jpg" \
  http://localhost:5000/extract-barcode \
  --output barcode.jpg
```

**Using JavaScript/Fetch:**
```javascript
const formData = new FormData();
formData.append('image', fileInput.files[0]);

const response = await fetch('http://localhost:5000/extract-barcode', {
  method: 'POST',
  body: formData
});

if (response.ok) {
  const blob = await response.blob();
  const url = URL.createObjectURL(blob);
  const a = document.createElement('a');
  a.href = url;
  a.download = 'barcode.jpg';
  a.click();
}
```

**Using C#:**
```csharp
using var client = new HttpClient();
using var form = new MultipartFormDataContent();

var imageStream = File.OpenRead("photo.jpg");
form.Add(new StreamContent(imageStream), "image", "photo.jpg");

var response = await client.PostAsync("http://localhost:5000/extract-barcode", form);

if (response.IsSuccessStatusCode)
{
    var barcodeBytes = await response.Content.ReadAsByteArrayAsync();
    File.WriteAllBytes("barcode.jpg", barcodeBytes);
}
```

## How It Works

1. **Upload:** User submits a JPG image containing a barcode
2. **Detection:** ZXing library scans the image and detects barcode location
3. **Extraction:** The smallest rectangle containing the barcode is identified
4. **Padding:** 10% padding is added around the barcode for context
5. **Cropping:** The image is cropped to the calculated region
6. **Optimization:** The cropped image is saved as JPG with 85% quality to minimize file size
7. **Return:** The barcode JPG is sent back to the client

## Supported Barcode Types

ZXing supports many barcode and 2D code formats:
- UPC-A, UPC-E
- EAN-8, EAN-13
- Code 128, Code 39
- QR Code
- Data Matrix
- PDF417
- And many more...

## Dependencies

- **ZXing.Net** (0.16.9): Barcode detection and decoding
- **System.Drawing.Common** (8.0.0): Image manipulation

## Project Structure

```
├── Program.cs              # Main application and API endpoint
├── BarcodeApi.csproj       # Project file with dependencies
├── appsettings.json        # Application configuration
└── README.md               # This file
```

## Configuration

Edit `appsettings.json` to customize:
- Logging levels
- Allowed hosts

## Future Enhancements

- [ ] Batch processing multiple images
- [ ] Barcode type specification
- [ ] Confidence threshold adjustments
- [ ] Multiple barcode detection and extraction
- [ ] Support for additional image formats (PNG, BMP, etc.)
- [ ] Database integration for barcode history

## Troubleshooting

### "No barcode detected in the image"
- Ensure the image contains a clear, readable barcode
- Try improving image quality/resolution
- Ensure adequate lighting in the original image

### "File must be a JPG image"
- Only JPG/JPEG formats are accepted
- Convert your image to JPG before uploading

### Port Already in Use
```bash
# Specify a different port
dotnet run --urls "http://localhost:5002"
```

## License

MIT License

## Support

For issues or questions, please open a GitHub issue.
