document.addEventListener('DOMContentLoaded', () => {
  const typingInput = document.getElementById('typing-input'); // 表示用の要素のIDを適宜設定してください
  const keyboardLayout = document.getElementById('keyboard-layout'); // キーボードレイアウトの要素のIDを適宜設定してください
  let romajiInput = ''; // ローマ字入力を蓄積する変数

  // ローマ字とひらがなの対応表
  const romajiToHiraganaMap = {
    'a': 'あ', 'i': 'い', 'u': 'う', 'e': 'え', 'o': 'お',
    'ka': 'か', 'ki': 'き', 'ku': 'く', 'ke': 'け', 'ko': 'こ',
    'sa': 'さ', 'shi': 'し', 'su': 'す', 'se': 'せ', 'so': 'そ',
    'ta': 'た', 'chi': 'ち', 'tsu': 'つ', 'te': 'て', 'to': 'と',
    'na': 'な', 'ni': 'に', 'nu': 'ぬ', 'ne': 'ね', 'no': 'の',
    'ha': 'は', 'hi': 'ひ', 'hu': 'ふ', 'he': 'へ', 'ho': 'ほ',
    'ma': 'ま', 'mi': 'み', 'mu': 'む', 'me': 'め', 'mo': 'も',
    'ya': 'や', 'yu': 'ゆ', 'yo': 'よ',
    'ra': 'ら', 'ri': 'り', 'ru': 'る', 're': 'れ', 'ro': 'ろ',
    'wa': 'わ', 'wo': 'を',
    'n': 'ん',
    'vu': 'ゔ',

    // 拗音
    'kya': 'きゃ', 'kyu': 'きゅ', 'kyo': 'きょ',
    'sha': 'しゃ', 'shu': 'しゅ', 'sho': 'しょ',
    'tya': 'ちゃ', 'tyu': 'ちゅ', 'tyo': 'ちょ',
    'cha': 'ちゃ', 'chu': 'ちゅ', 'cho': 'ちょ',
    'nya': 'にゃ', 'nyu': 'にゅ', 'nyo': 'にょ',
    'hya': 'ひゃ', 'hyu': 'ひゅ', 'hyo': 'ひょ',
    'fa': 'ふぁ', 'fi': 'ふぃ', 'fyu': 'ふゅ', 'fe': 'ふぇ', 'fo': 'ふぉ',
    'mya': 'みゃ', 'myu': 'みゅ', 'myo': 'みょ',
    'rya': 'りゃ', 'ryu': 'りゅ', 'ryo': 'りょ',
    'gya': 'ぎゃ', 'gyu': 'ぎゅ', 'gyo': 'ぎょ',
    'ja': 'じゃ', 'ju': 'じゅ', 'jo': 'じょ',
    'bya': 'びゃ', 'byu': 'びゅ', 'byo': 'びょ',
    'pya': 'ぴゃ', 'pyu': 'ぴゅ', 'pyo': 'ぴょ',
    'va': 'ゔぁ', 'vi': 'ゔぃ', 'vu': 'ゔ', 've': 'ゔぇ', 'vo': 'ゔぉ',
    'dya': 'ぢゃ', 'dyu': 'ぢゅ', 'dyo': 'ぢょ',
    'dha': 'ぢゃ', 'dhi': 'ぢぃ', 'dhu': 'ぢゅ', 'dhe': 'ぢぇ', 'dho': 'ぢょ',
    'wi': 'うぃ', 'we': 'うぇ', 'wo': 'うぉ',

    // 撥音
    'n\'': 'ん', // "n'" は単独で "ん" を表す

    // 追加のひらがな
    'ga': 'が', 'gi': 'ぎ', 'gu': 'ぐ', 'ge': 'げ', 'go': 'ご',
    'za': 'ざ', 'ji': 'じ', 'zu': 'ず', 'ze': 'ぜ', 'zo': 'ぞ',
    'da': 'だ', 'dji': 'ぢ', 'dzu': 'づ', 'de': 'で', 'do': 'ど',
    'ba': 'ば', 'bi': 'び', 'bu': 'ぶ', 'be': 'べ', 'bo': 'ぼ',
    'pa': 'ぱ', 'pi': 'ぴ', 'pu': 'ぷ', 'pe': 'ぺ', 'po': 'ぽ',

    // 促音
    'kka': 'っか', 'kki': 'っき', 'kku': 'っく', 'kke': 'っけ', 'kko': 'っこ',
    'ssa': 'っさ', 'ssi': 'っし', 'sshi': 'っし', 'ssu': 'っす', 'sse': 'っせ', 'sso': 'っそ',
    'tta': 'った', 'cchi': 'っち',  'tti': 'っち', 'ttu': 'っつ', 'tte': 'って', 'tto': 'っと',
    'nna': 'っな', 'nni': 'っに', 'nnu': 'っぬ', 'nne': 'っね', 'nno': 'っの',
    'ppa': 'っぱ', 'ppi': 'っぴ', 'ppu': 'っぷ', 'ppe': 'っぺ', 'ppo': 'っぽ',
    'mma': 'っま', 'mmi': 'っみ', 'mmu': 'っむ', 'mme': 'っめ', 'mmo': 'っも',
    'yya': 'っや', 'yyu': 'っゆ', 'yyo': 'っよ',
    'rri': 'っり', 'rru': 'っる', 'rre': 'っれ', 'rro': 'っろ',
    'wwa': 'っわ', 'wwo': 'っを',
    
    // 特殊な組み合わせ
    'ji': 'じ', 'zu': 'ず', // "ji" と "zu" の別の表記
    'si': 'し', 'chi': 'ち', 'tsu': 'つ', // "si", "chi", "tsu" の追加
    'fu': 'ふ', // "fu" の追加

    // 長音
    'aa': 'あー', 'ii': 'いー', 'uu': 'うー', 'ee': 'えー', 'oo': 'おー',
    'ou': 'おう', 'ei': 'えい',
    '-': 'ー', // 長音記号

    // その他のルール
    'xa': 'ぁ', 'xi': 'ぃ', 'xu': 'ぅ', 'xe': 'ぇ', 'xo': 'ぉ',
    'la': 'ぁ', 'li': 'ぃ', 'lu': 'ぅ', 'le': 'ぇ', 'lo': 'ぉ',
    'ltu': 'っ', 'xtu': 'っ'

  };


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

  keyboardLayout.addEventListener('click', (event) => {
    if (event.target.classList.contains('key') && !['shift', 'return', 'space'].includes(event.target.textContent.toLowerCase())) {
      const keyValue = event.target.textContent.toLowerCase();
      if (keyValue === 'delete') {
        romajiInput = romajiInput.slice(0, -1);
        typingInput.value = typingInput.value.slice(0, -1);
      } else {
        romajiInput += keyValue;
        let { match, remainder } = convertRomajiToHiragana(romajiInput);
        console.log(match, remainder) // debug
        if (match) {
          typingInput.value += match;
          romajiInput = remainder;
        } else if (romajiInput.length > 2 && !romajiToHiraganaMap[romajiInput] && remainder) {
          // 不適切な入力があった場合、ローマ字入力をリセット
          romajiInput = ''; // 入力をリセットして新たな入力を受け付ける
        }
      }
    }
  });
});

