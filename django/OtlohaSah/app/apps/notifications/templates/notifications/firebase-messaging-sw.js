importScripts('https://www.gstatic.com/firebasejs/8.10.0/firebase-app.js');
importScripts('https://www.gstatic.com/firebasejs/8.10.0/firebase-messaging.js');

// Initialize the Firebase app in the service worker
firebase.initializeApp({
  apiKey: "AIzaSyBEHSU-CNMSKQsGvKVVFT_3rtH653o9NDM",
  authDomain: "otlohasah-test.firebaseapp.com",
  projectId: "otlohasah-test",
  storageBucket: "otlohasah-test.appspot.com",
  messagingSenderId: "339760843013",
  appId: "1:339760843013:web:eb0e67db4c08695b138f6c"
});

// Retrieve an instance of Firebase Messaging
const messaging = firebase.messaging();

// Customize notification behavior
messaging.setBackgroundMessageHandler((payload) => {
  const notification = JSON.parse(payload.data.notification);
  const notificationTitle = notification.title;
  const notificationOptions = {
    body: notification.body,
    icon: notification.icon,
    image: notification.image
    // Additional customization options
  };

  // Show the notification
  return self.registration.showNotification(
    notificationTitle,
    notificationOptions
  );
});
