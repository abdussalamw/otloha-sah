"use strict";

var AudioPlayerHandlersInitialized = false;
var AudioPlayerObject = {
  localeSrc: {},
  set src(obj) {
    var audio = new Audio(obj.src)
    audio.addEventListener('ended', function () {
      obj.setIcon('play')
    })
    this.localeSrc = {...obj, audio}
  },
  get src() {
    return this.localeSrc
  },
  hasSrc() {
    return !!Object.keys(this.localeSrc).length
  },
  play() {
    return this.src.audio.play()
  },
  pause() {
    return this.src.audio.pause()
  },
  paused() {
    return this.hasSrc() ? this.src.audio.paused : false
  }
}

var AudioPlayer = function (element) {
  var the = this

  if (typeof element === "undefined" || element === null) {
    return;
  }

  var playIcon = `<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
        <path d="M16.9 10.7L7 5V19L16.9 13.3C17.9 12.7 17.9 11.3 16.9 10.7Z" fill="currentColor"></path>
      </svg>`,
      pauseIcon = `<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
        <path opacity="0.3" d="M21 22H14C13.4 22 13 21.6 13 21V3C13 2.4 13.4 2 14 2H21C21.6 2 22 2.4 22 3V21C22 21.6 21.6 22 21 22Z" fill="currentColor"></path>
        <path d="M10 22H3C2.4 22 2 21.6 2 21V3C2 2.4 2.4 2 3 2H10C10.6 2 11 2.4 11 3V21C11 21.6 10.6 22 10 22Z" fill="currentColor"></path>
      </svg>`,
      corruptIcon = `<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
        <path opacity="0.3" d="M6.7 19.4L5.3 18C4.9 17.6 4.9 17 5.3 16.6L16.6 5.3C17 4.9 17.6 4.9 18 5.3L19.4 6.7C19.8 7.1 19.8 7.7 19.4 8.1L8.1 19.4C7.8 19.8 7.1 19.8 6.7 19.4Z" fill="currentColor"></path>
        <path d="M19.5 18L18.1 19.4C17.7 19.8 17.1 19.8 16.7 19.4L5.40001 8.1C5.00001 7.7 5.00001 7.1 5.40001 6.7L6.80001 5.3C7.20001 4.9 7.80001 4.9 8.20001 5.3L19.5 16.6C19.9 16.9 19.9 17.6 19.5 18Z" fill="currentColor"></path>
      </svg>`

  var _setIcon = function (icon) {
    var iconContainer = element.querySelector('.audio-icon'),
        iconSvg
    if (!iconContainer)
      return
    switch (icon) {
      case 'play':
        iconSvg = playIcon
        break
      case 'pause':
        iconSvg = pauseIcon
        iconContainer.classList.add('text-info')
        break
      case 'corrupt':
        iconSvg = corruptIcon
        iconContainer.classList.add('text-danger')
    }
    iconContainer.innerHTML = iconSvg
  }

  var _play = function () {
    AudioPlayerObject.play()
        .then(function () {
          _setIcon('pause')
        })
        .catch(function () {
          _setIcon('corrupt')
        })
  }

  var _init = function () {
    the.uid = KTUtil.getUniqueId('audio-player');
    the.element = element;
    the.disabled = false;
    the.src = element.getAttribute('data-src')
    // the.audio = _createAudio()

    _setIcon('play')
    // Set initialized
    the.element.setAttribute('data-audio', 'true');

    KTUtil.data(the.element).set('audio-player', the);
  }

  var _construct = function () {
    if (KTUtil.data(element).has('audio-player') === true) {
      the = KTUtil.data(element).get('audio-player');
    } else {
      _init();
    }
  }

  _construct()

  var _click = function (element, e) {
    e.preventDefault();

    if (AudioPlayerObject.hasSrc()) {
      if (AudioPlayerObject.src.uid === the.uid) {
        return AudioPlayerObject.paused() ? _play() : AudioPlayerObject.pause()
      } else {
        AudioPlayerObject.pause()
        AudioPlayerObject.src = the
        _play()
      }
    } else {
      AudioPlayerObject.src = the
      _play()
    }
  }

  the.click = function (element, e) {
    return _click(element, e)
  }
  the.setIcon = function (icon) {
    return _setIcon(icon)
  }
}

AudioPlayer.getInstances = function (element) {
  if (!element) {
    return null;
  }

  if (KTUtil.data(element).has('audio-player')) {
    return KTUtil.data(element).get('audio-player');
  }
  return null;
}

AudioPlayer.createInstances = function (selector = '[data-toggle="audio"]') {
  var elements = document.querySelectorAll(selector);
  if (elements && elements.length > 0) {
    for (var i = 0, len = elements.length; i < len; i++) {
      new AudioPlayer(elements[i]);
    }
  }
}

AudioPlayer.updateAllIcons = function (selector = '[data-toggle="audio"]') {
  var elements = document.querySelectorAll(selector), audio

  if (elements && elements.length > 0) {
    for (var i = 0, len = elements.length; i < len; i++) {
      audio = AudioPlayer.getInstances(elements[i])
      if (audio !== null) {
        audio.setIcon('play')
      }
    }
  }
}

// Global handlers
AudioPlayer.initHandlers = function () {
  $(document).on('click', '[data-toggle="audio"]', function (e) {
    var audio = AudioPlayer.getInstances(this)
    if (audio !== null) {
      AudioPlayer.updateAllIcons()
      audio.click(this, e)
    }
  })
}

// Global initialization
AudioPlayer.init = function () {
  AudioPlayer.createInstances();

  if (AudioPlayerHandlersInitialized === false) {
    AudioPlayer.initHandlers();

    AudioPlayerHandlersInitialized = true;
  }
}

// On document ready
if (document.readyState === "loading") {
  document.addEventListener("DOMContentLoaded", function () {
    AudioPlayer.init();
  });
} else {
  AudioPlayer.init();
}