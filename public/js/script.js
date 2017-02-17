function validateFile() {
	var input = document.getElementById('imageUpload');
	var fileName = input.value;
	if (fileName.localeCompare("") != 0) {
		var extension = fileName.substr(fileName.length - 4);
		if (extension.localeCompare(".jpg") != 0 && extension.localeCompare(".png") != 0 && extension.localeCompare(".bmp") != 0) {
			alert("File uploaded invalid, allowed extensions : JPG PNG BMP");
			input.value = "";
			return false;
		}
	}
	return true;
}

$(document).ready(function() {
	$(".deleteButton").on('click', function () {
		$.ajax({
			url: "/"+$(this).context.value,
			type: "DELETE",
		});
		$("#item"+$(this).context.value).remove();
	});
	
});
