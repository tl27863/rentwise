importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-messaging.js");

firebase.initializeApp({
  apiKey: "AIzaSyA3Dw2uzI2nKqlv0ylha4cH3XmLymu-R8g",
  authDomain: "rentw-28b34.firebaseapp.com",
  projectId: "rentw-28b34",
  storageBucket: "rentw-28b34.appspot.com",
  messagingSenderId: "260281430203",
  appId: "1:260281430203:web:f41e116668207f2d66399e",
  measurementId: "G-2B7Q63SZJF"
});

const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((message) => {
  console.log("onBackgroundMessage", message);
});

