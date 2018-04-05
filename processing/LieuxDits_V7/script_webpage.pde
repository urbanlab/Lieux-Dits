/*
<!DOCTYPE HTML>
<html>
<head>

</head>
<body>
 <script type="text/javascript">

  var recognition, u;
  
 //document.write("Lieux Dits"); 
 

speechSynthesis.onvoiceschanged = function () 
{
  // get the voice
  var voices = speechSynthesis.getVoices();
  u.voice = voices[8];
  u.pitch = 1;  // accepted values: 0-2 inclusive, default value: 1
  u.rate = 1; // accepted values: 0.1-10 inclusive, default value: 1
  u.volume = 1; // accepted values: 0-1, default value: 1
  u.lang = 'fr-FR';
}

function WebKitKill()
{
  if(recognition != null)
  {
    recognition=null;
  //delete recognition;
  }
  if(u != null)
  {
  u=null;
  //delete u;
  }
  
}


function WebKitStart()
{
  if(recognition == null) 
  {
    recognition = new webkitSpeechRecognition();
    recognition.lang = "fr-FR";
    recognition.continuous = false;
    recognition.interimResults = false;
    recognition.maxAlternatives = 1;
    // Start the recognition
    recognition.start();
  }
  
  if(u == null) u = new SpeechSynthesisUtterance();
}

// We need to check if the browser supports WebSockets
if ("WebSocket" in window)
{
     // Before we can connect to the WebSocket, we need to start it in Processing.
     var ws = new WebSocket("ws://localhost:1337/p5websocket");
   WebKitStart();
} 
else 
{
  // The browser doesn't support WebSocket
  alert("WebSocket NOT supported by your Browser!");
}

recognition.onresult = function(event) 
{
    // Get the current result from the results object
    var transcript="";
  transcript += event.results[event.results.length-1][0].transcript;
    // Send the result string via WebSocket to the running Processing Sketch  
  ws.send(transcript);
  document.write(transcript);
  document.write("<br>");
}
 

// Restart the recognition on timeout
recognition.onend = function()
{
    recognition.start();
  //document.close();
  //document.open();
  document.write("!");
  //document.write("<br>");
}
recognition.onaudiostart = function() 
{    
}
recognition.onspeechstart = function() 
{
}
recognition.onspeechend = function()
{
}
recognition.onnomatch = function() 
{
}

ws.onmessage = function (event) 
{
  if(event.data == "*") 
  {
  location.reload(true);
  document.write("Reloading page");
  document.write("<br>");
  }
  else
  {
  if(u != null)
  {
  u.text = event.data;
  speechSynthesis.speak(u);
  }
  }
  document.write(">>");
  document.write(event.data);
  document.write("<br>");
  
}
    
</script>
</body>
</html>
*/