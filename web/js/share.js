// Web Share API를 직접 호출하는 함수
window.webShare = function(title, text, url) {
  return new Promise((resolve, reject) => {
    if (navigator.share) {
      navigator.share({
        title: title,
        text: text,
        url: url
      })
      .then(() => {
        resolve('success');
      })
      .catch((error) => {
        reject(error);
      });
    } else {
      reject(new Error('Web Share API not supported'));
    }
  });
};

// Web Share API 지원 확인 함수
window.isWebShareSupported = function() {
  return navigator.share !== undefined;
};

