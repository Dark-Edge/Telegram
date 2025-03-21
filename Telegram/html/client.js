// script.js

// Quand le script reçoit un message du côté client (Lua)
window.addEventListener('message', function(event) {
  const data = event.data;
  const subjectx 	= event.data.subject
  const messagex	= event.data.message
  const senderx		= event.data.sender
  const coordsx		= event.data.coords
  const datex		= event.data.date
  const idx			= event.data.id
  if (data.type === 'show') {
    // Afficher la lettre
    document.getElementById('letter').style.display = 'block';
	document.getElementById('date').innerHTML = "Reçu le: "+datex;
	document.getElementById('localisation').innerHTML ="A "+coordsx;
	document.getElementById('subject').innerHTML = subjectx;
	document.getElementById('message').innerHTML = messagex;
	document.getElementById('signature').innerHTML = "Signé: "+senderx;
  }
  if (data.type === 'show2') {
    // Afficher la lettre
    document.getElementById('ticket').style.display = 'block';
	document.getElementById('ticket_content').innerHTML = "Votre N° de Boite mail est le : "+idx;
  }
});

// Fonction pour fermer l'UI
function closeUI() {
	document.getElementById('letter').style.display = 'none';
	document.getElementById('ticket').style.display = 'none';
  // Appel de l'événement NUI 'closeUI' côté Lua
	Post('http://Telegram/close')
    .catch(err => console.error(err));
}




Post = function(url,data) {
    var d = (data ? data : {});
    $.post(url,JSON.stringify(d));
};

$(document).keydown(function(e){
    var close = 27, close2 = 8;
    switch (e.keyCode) {       
        case close:
		document.getElementById('letter').style.display = 'none';
		document.getElementById('ticket').style.display = 'none';
        Post('http://Telegram/close')
        break;

        case close2:
		document.getElementById('letter').style.display = 'none';
		document.getElementById('ticket').style.display = 'none';
        Post('http://Telegram/close')
        break;
    }
});