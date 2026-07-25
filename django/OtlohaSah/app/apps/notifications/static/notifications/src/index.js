import {initializeApp} from "https://www.gstatic.com/firebasejs/10.0.0/firebase-app.js"
import {getMessaging, getToken, onMessage} from "https://www.gstatic.com/firebasejs/10.0.0/firebase-messaging.js";

const app = initializeApp({
  apiKey: "AIzaSyBEHSU-CNMSKQsGvKVVFT_3rtH653o9NDM",
  authDomain: "otlohasah-test.firebaseapp.com",
  projectId: "otlohasah-test",
  storageBucket: "otlohasah-test.appspot.com",
  messagingSenderId: "339760843013",
  appId: "1:339760843013:web:eb0e67db4c08695b138f6c"
})

const messaging = getMessaging(app)

getToken(messaging, {vapidKey: "BPSjo08Sj90Rh7-dV6PdSEhn10DI_J3rEHlbOQ_pnNn9pFqib0poUOj_kGtLIEDfoEhffklICImbp1Acl7fY55s"})
    .then((currentToken) => {
      if (currentToken) {
        console.log(currentToken)
      } else {
        // Show permission request UI
        console.log('No registration token available. Request permission to generate one.');
        // ...
      }
    }).catch((err) => {
  console.log('An error occurred while retrieving token. ', err);
});

onMessage(messaging, (payload) => {

  console.log(payload)

});