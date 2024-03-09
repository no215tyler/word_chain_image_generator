import { romajiToHiraganaMap } from "./romajiToHiraganaMap.js"; 
// 【グローバル変数】
const typingInput = document.getElementById('typing-input'); // 表示用の要素のIDを適宜設定してください
const keyboardLayout = document.getElementById('keyboard-layout'); // キーボードレイアウトの要素のIDを適宜設定してください
const feedbackMessage = document.getElementById('feedback-message'); // タイピング正誤判定のフィードバック
const wordChainStatus = document.getElementById('word-chain-status'); // しりとり状況表示領域の要素
let romajiInput = ''; // ローマ字入力を蓄積する変数
let lastArrowElement = null; // 最後の矢印要素を管理するための変数

document.addEventListener('DOMContentLoaded', () => {
  
  // フィードバックメッセージを表示する関数
  function showFeedback(msg) {
    feedbackMessage.textContent = msg; // メッセージを表示
    setTimeout(() => {
      feedbackMessage.textContent = ''; // 2秒後にメッセージを消去
    }, 2000);
  }

  // ローマ字からひらがなへの変換を試みる関数
  function convertRomajiToHiragana(romaji) {
    // 'n'に続く母音の定義
    const vowels = ['a', 'i', 'u', 'e', 'o'];
  
    if (romaji === 'n') {
      // 「n」の後にさらなる入力を待つ
      return { match: '', remainder: 'n' };
    } else if (romaji.startsWith('n')) {
      // 'n'に続く文字が母音であれば、直接変換
      if (vowels.includes(romaji[1])) {
        const potentialMatch = 'n' + romaji[1]; // 'na', 'ni', 'nu', 'ne', 'no'
        if (romajiToHiraganaMap[potentialMatch]) {
          return { match: romajiToHiraganaMap[potentialMatch], remainder: romaji.substring(2) };
        }
      }
      // 'ny'に続く場合、拗音の入力を待つ
      else if (romaji[1] === 'y' && !romajiToHiraganaMap[romaji.substring(0, 3)]) {
        return { match: '', remainder: romaji };
      }
      // 'n'のみで、マップに存在しない場合は「ん」として扱う
      else if (!romajiToHiraganaMap[romaji] && romaji.length === 2) {
        return { match: 'ん', remainder: romaji.substring(1) };
      }
    }
  
    for (let i = romaji.length; i > 0; i--) {
      const subRomaji = romaji.substring(0, i);
      if (romajiToHiraganaMap[subRomaji]) {
        return {
          match: romajiToHiraganaMap[subRomaji],
          remainder: romaji.substring(i)
        };
      }
    }
  
    // 特に「n」が最後にある場合の処理
    if (romaji.endsWith('n')) {
      return { match: 'ん', remainder: '' };
    }
  
    return { match: '', remainder: romaji };
  }

  // 「return」キーがクリックされた場合の処理
  function addPhraseAndArrow(phrase) {
    // 最後に追加された矢印があれば、それを表示する
    if (lastArrowElement) {
      lastArrowElement.style.display = 'inline-block'; // CSSで非表示にしていた場合
    }

    // フレーズの追加
    const phraseElement = document.createElement('div');
    phraseElement.textContent = phrase;
    phraseElement.className = 'word-item';
    wordChainStatus.appendChild(phraseElement);

    // 新しい矢印の作成（ただし表示はしない）
    const arrowElement = document.createElement('div');
    arrowElement.textContent = '▶︎';
    arrowElement.className = 'arrow-item';
    arrowElement.style.display = 'none'; // 最初は表示しない
    wordChainStatus.appendChild(arrowElement);

    // 最後の矢印要素を更新
    lastArrowElement = arrowElement;
  }

  keyboardLayout.addEventListener('click', (event) => {
    if (event.target.classList.contains('key') && !['shift', 'space'].includes(event.target.textContent.toLowerCase())) {
      const keyValue = event.target.textContent.toLowerCase();
      if (keyValue === 'delete') {
        romajiInput = romajiInput.slice(0, -1);
        typingInput.value = typingInput.value.slice(0, -1);
      } else if (keyValue === 'return') {
        // 「return」キーがクリックされた場合、しりとり状況を更新
        if (typingInput.value.trim().length > 0) { // 空でない入力がある場合のみ処理
          addPhraseAndArrow(typingInput.value); // フレーズと矢印の追加
          typingInput.value = ''; // typing-input内の入力文字をリセット
          romajiInput = ''; // ローマ字入力もリセット
        }
      } else {
        romajiInput += keyValue;
        let { match, remainder } = convertRomajiToHiragana(romajiInput);

        if (match) {
          typingInput.value += match;
          romajiInput = remainder;
        } else if (remainder.length === 3 && !romajiToHiraganaMap[remainder]) {
          // フィードバック関数を使用して不適切な入力をユーザーに通知
          showFeedback("NG!");
          romajiInput = ''; // 入力をリセットして新たな入力を受け付ける
        }
      }
    }
  });

  typingInput.addEventListener('keypress', (event) => {
    if (event.key === 'Enter') {
      if (typingInput.value.trim().length > 0) { // 空でない入力がある場合のみ処理
        addPhraseAndArrow(typingInput.value); // フレーズと矢印の追加
        typingInput.value = ''; // typing-input内の入力文字をリセット
        romajiInput = ''; // ローマ字入力もリセット
        event.preventDefault(); // フォーム送信の防止
      }
    }
  });

  // 【物理キーボードとの連動】
  document.addEventListener('keydown', (event) => {
    if (event.key === 'Backspace') {
      // Backspaceが押された場合の処理
      romajiInput = romajiInput.slice(0, -1);
      typingInput.value = typingInput.value.slice(0, -1);
      event.preventDefault(); // フォームの送信を防ぐ
    } else if (event.key === 'Enter') {
      // Enterが押された場合の処理
      if (typingInput.value.trim().length > 0) {
        addPhraseAndArrow(typingInput.value);
        typingInput.value = '';
        romajiInput = '';
      }
      event.preventDefault(); // フォームの送信を防ぐ
    } else {
      // 英字キーが押された場合の処理
      const key = event.key.toLowerCase();
      // 特定のキー(コントロールキーなど)を無視
      if (key.length === 1 && key.match(/[a-z]/i)) {
        romajiInput += key;
        let { match, remainder } = convertRomajiToHiragana(romajiInput);

        if (match) {
          typingInput.value += match;
          romajiInput = remainder;
        } else if (remainder.length === 3 && !romajiToHiraganaMap[remainder]) {
          // 不適切な入力をユーザーに通知
          showFeedback("NG!");
          romajiInput = ''; // 入力をリセット
        }
        
        // 英字キーのデフォルトの入力処理をキャンセル
        event.preventDefault();        
      }

      if (key === "-") { 
        event.preventDefault(); // デフォルトのイベントをキャンセル
        typingInput.value += "ー"; 
      }
    }

    // 物理キーボードのキー入力をハイライト
    const virtualKeyElement = document.querySelector(`.key[data-key="${event.key.toLowerCase()}"]`);
    if (virtualKeyElement) {
      virtualKeyElement.classList.add('active');
    }
  });

  document.addEventListener('keyup', (event) => {
    // キーが離されたときのハイライト削除
    const key = event.key;
    const virtualKeyElement = document.querySelector(`.key[data-key="${key.toLowerCase()}"]`);
    if (virtualKeyElement) {
      virtualKeyElement.classList.remove('active');
    }
  });
});