function validateFile() {
	var input = document.getElementById('imageUpload');
	var fileName = input.value;
	if (fileName != "") {
		var extension = fileName.substr(fileName.length - 4);
		if (extension != ".jpg" || extension != ".png" || extension != ".bmp") {
			alert("File uploaded invalid, allowed extensions : JPG PNG BMP");
			input.value = "";
			return false;
		}
	}
	return true;
}