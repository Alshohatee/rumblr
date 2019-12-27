


var createPost = document.getElementById("create-post");
var btn = document.getElementById("myBtn");
var span = document.getElementsByClassName("close-btn")[0];

btn.onclick = function() {
  createPost.style.display = "block";
}

span.onclick = function() {
  createPost.style.display = "none";
}

// When the user clicks anywhere outside of the modal, close it
window.onclick = function(event) {
  if (event.target == createPost) {
    createPost.style.display = "none";
  }
}
