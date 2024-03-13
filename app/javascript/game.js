import { romajiToHiraganaMap } from "romajiToHiraganaMap"; 
import { kanaMap } from "kana_conversion";
// 【グローバル変数】
const typingInput = document.getElementById('typing-input');
const keyboardLayout = document.getElementById('keyboard-layout');
const feedbackMessage = document.getElementById('feedback-message'); // タイピング正誤判定のフィードバック
const wordChainStatus = document.getElementById('word-chain-status'); // しりとり状況表示領域の要素
let romajiInput = ''; // ローマ字入力を蓄積する変数
let lastArrowElement = null; // 最後の矢印要素を管理するための変数
let usedWords = []; // これまでに入力された単語を保持する配列

document.addEventListener('DOMContentLoaded', () => {

  // フィードバックメッセージを表示する関数
  function showFeedback(msg) {
    feedbackMessage.innerHTML = msg.replace(/\n/g, '<br>'); // メッセージを表示、\n を <br> に置換
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

  // #################################
  //    しりとりのルールチェックを行う関数
  // #################################
  // 平仮名またはカタカナを統一的に扱うための関数
  function normalizeKana(word) {
    return [...word].map(char => kanaMap[char] || char).join('');
  }

  function isValidShiritoriWord(word) {
    // 入力された単語を平仮名に正規化
    let normalizedInput = normalizeKana(word);

    // 既に使われた単語リストを平仮名に正規化
    let normalizedUsedWords = usedWords.map(w => normalizeKana(w));

    // 正規化された単語が既に使用されたかチェック
    if (normalizedUsedWords.includes(normalizedInput)) {
        playNgSound();
        showFeedback("もう使われたフレーズだよ！");
        return false;
    }

    // 前回の単語の最終文字または拗音を取得（平仮名に正規化）
    let lastWord = normalizedUsedWords.length > 0 ? normalizedUsedWords[normalizedUsedWords.length - 1] : '';
    let lastChar = lastWord.slice(-1);
    if (lastChar === 'ー') {
        lastChar = lastWord.slice(-2, -1);
    }

    // 拗音で終わる場合、拗音で次の単語を開始する必要がある
    let yoonEnd = lastWord.slice(-2);
    let isYoon = /きゃ|きゅ|きょ|しゃ|しゅ|しょ|しぇ|ちゃ|ちゅ|ちょ|にゃ|にゅ|にょ|ひゃ|ひゅ|ひょ|ふぁ|ふぃ|ふゅ|ふぇ|ふぉ|みゃ|みゅ|みょ|りゃ|りゅ|りょ|ぎゃ|ぎゅ|ぎょ|じゃ|じゅ|じょ|びゃ|びゅ|びょ|ぴゃ|ぴゅ|ぴょ|てぃ|でぃ|てゃ|でゃ|てゅ|でゅ|てょ|でょ|てぇ|でぇ/.test(yoonEnd);

    if (normalizedUsedWords.length > 0 && !((isYoon && normalizedInput.startsWith(yoonEnd)) || (!isYoon && normalizedInput.startsWith(lastChar)))) {
      playNgSound();
      showFeedback(isYoon ? `「${yoonEnd}」で始めてね！` : `「${lastChar}」から始めてね！`);
      return false;
    }

    if (normalizedInput.endsWith('ん')) {
      playNgSound();
      gameOver();
      return true;
    }

    return true;
  }

  // 「return」キーがクリックされた場合の処理
  function addPhraseAndArrow(phrase) {
    // 入力された単語がしりとりのルールに適合しているかチェック
    if (!isValidShiritoriWord(phrase)) return;

    // 単語を使用済み配列に追加（正規化してから追加）
    usedWords.push(normalizeKana(phrase));

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
    if (event.target.classList.contains('key') && !['shift'].includes(event.target.textContent.toLowerCase())) {
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
      } else if (keyValue === 'space') {
        // スペースキーがクリックされた場合、カナのトグルを実行
        typingInput.value = toggleKana(typingInput.value);
      } else {
        romajiInput += keyValue;
        let { match, remainder } = convertRomajiToHiragana(romajiInput);

        if (match) {
          typingInput.value += match;
          romajiInput = remainder;
        } else if (remainder.length === 3 && !romajiToHiraganaMap[remainder]) {
          // フィードバック関数を使用して不適切な入力をユーザーに通知
          playNgSound();
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
          playNgSound();
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


function toggleKana(text) {
  // ひらがなとカタカナの対応表
  const hiragana = "あいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほまみむめもやゆよらりるれろわをんがぎぐげござじずぜぞだぢづでどばびぶべぼぱぴぷぺぽぁぃぅぇぉゃゅょっゔ";
  const katakana = "アイウエオカキクケコサシスセソタチツテトナニヌネノハヒフヘホマミムメモヤユヨラリルレロワヲンガギグゲゴザジズゼゾダヂヅデドバビブベボパピプペポァィゥェォャュョッヴ";
  
  let convertedText = "";
  for (let i = 0; i < text.length; i++) {
      const char = text[i];
      if (hiragana.includes(char)) {
          // ひらがなからカタカナへ変換
          const index = hiragana.indexOf(char);
          convertedText += katakana[index];
      } else if (katakana.includes(char)) {
          // カタカナからひらがなへ変換
          const index = katakana.indexOf(char);
          convertedText += hiragana[index];
      } else {
          // その他の文字はそのまま
          convertedText += char;
      }
  }
  return convertedText;
}

// スペースキー押下時のイベントリスナー
document.addEventListener('keydown', function(event) {
  if (event.key === ' ') { // スペースキーが押された場合
      const currentText = typingInput.value;
      const toggledText = toggleKana(currentText);
      typingInput.value = toggledText; // 変換後のテキストを入力フィールドに設定
      event.preventDefault(); // スペースキーのデフォルトの動作（スペースの挿入）を防ぐ
  }
});

// #########################
//     SEのON / OFFトグル
// #########################
// SEのON/OFFを切り替えるイメージ要素
const seToggleImage = document.getElementById('se-toggle-image'); // HTMLにid="se-toggle-image"のimg要素を追加する

let isSeEnabled = true; // SEの再生状態を管理

// イメージクリックイベントの定義
seToggleImage.addEventListener('click', () => {
  isSeEnabled = !isSeEnabled; // SEの状態を切り替え
  seToggleImage.src = isSeEnabled ? './images/volume_on.jpg' : './images/volume_off.jpg'; // イメージのソースを更新
});

// SEを再生する関数（既存のplayNgSound関数に変更を加える）
function playNgSound() {
  if (!isSeEnabled) return; // SEがOFFの場合はここで処理を終了
  const ngSound = new Audio('/sounds/ng_sound.mp3');
  ngSound.play().catch(e => console.error("Audio play failed:", e));
}

// #################################
//       ゲーム終了時の処理
// #################################
function gameOver() {
  const gameOverPopup = document.getElementById('game-over-popup');
  gameOverPopup.style.display = 'flex'; // ポップアップを表示

  const restartButton = document.getElementById('restart-game');
  restartButton.focus(); // リスタートボタンにフォーカスをあてる
  // クリックまたはEnterキー押下でリスタートするイベントリスナーを追加
  function restartOnAction(event) {
    // クリックされた、またはEnterキーが押された場合にリスタート
    if (event.type === 'click' || (event.type === 'keydown' && event.key === 'Enter')) {
      restartGame();

      // イベントリスナーを削除
      restartButton.removeEventListener('click', restartOnAction);
      document.removeEventListener('keydown', restartOnAction);
    }
  }

  restartButton.addEventListener('click', restartOnAction);
  document.addEventListener('keydown', restartOnAction);
}


// #################################
//       ゲームをリスタートする関数
// #################################
function restartGame() {
  const gameOverPopup = document.getElementById('game-over-popup');
  gameOverPopup.style.display = 'none'; // ポップアップを非表示

  // ゲームの状態を初期化
  typingInput.value = '';
  romajiInput = '';
  usedWords = [];
  if (lastArrowElement) {
    lastArrowElement.style.display = 'none'; // 最後の矢印を非表示に
    lastArrowElement = null;
  }
  // 「しりとりの状況」以外の要素をword-chain-statusから削除
  const children = wordChainStatus.children;
  for (let i = children.length - 1; i >= 0; i--) {
    const child = children[i];
    if (!child.classList.contains('word-chain-status-heading')) {
      wordChainStatus.removeChild(child);
    }
  }
}
