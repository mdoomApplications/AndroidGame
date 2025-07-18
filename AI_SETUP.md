# 🤖 AI SETUP - Gemini TTS & Speech Recognition

## 🎯 Jak aktivovat AI funkce:

### 1. Získej Gemini API klíč
1. Jdi na https://makersuite.google.com/app/apikey
2. Vytvoř nový API klíč
3. Zkopíruj ho

### 2. Nastavení v kódu
V `index.html` najdi řádek:
```javascript
const GEMINI_API_KEY = 'YOUR_GEMINI_API_KEY_HERE';
```

Nahraď `YOUR_GEMINI_API_KEY_HERE` svým API klíčem:
```javascript
const GEMINI_API_KEY = 'AIzaSyC...tvůj-api-klíč';
```

### 3. Jak používat

#### 🎤 Mluvení s dráčkem
1. Klikni na **"POVÍDÁNÍ 🎤"**
2. Povolí přístup k mikrofonu
3. Mluv k dráčkovi
4. Dráček ti odpoví hlasem!

#### 🚫 Bez API klíče
- Hra funguje i bez API klíče
- Používá předdefinované odpovědi
- Stále má TTS (text-to-speech)

## 🎮 Funkce

### ✅ Speech Recognition
- Rozpoznávání češtiny
- Vizuální feedback (zelený border kolem dráčka)
- Fallback na text input

### ✅ Text-to-Speech
- Český hlas
- Vyšší tón pro dráčka (pitch: 1.2)
- Automatické přerušení předchozí řeči

### ✅ Gemini AI
- Inteligentní odpovědi
- Zná statistiky dráčka
- Přátelský dětský jazyk
- Emotikony

### ✅ UI/UX
- Floating zprávy
- Vizuální feedback
- Zvýšení nálady po povídání
- Funkce i pro mrtvé dráčky (varování)

## 🔧 Troubleshooting

### Mikrofon nefunguje
- Zkontroluj povolení v prohlížeči
- Zkus HTTPS (ne HTTP)
- Fallback: text input dialog

### TTS nefunguje
- Zkontroluj nastavení hlasitosti
- Zkus jiný prohlížeč
- Některé browsery potřebují uživatelskou akci

### API nefunguje
- Zkontroluj API klíč
- Zkontroluj CORS
- Fallback: předdefinované odpovědi

## 📱 Podpora

### ✅ Podporováno
- Chrome (desktop + mobile)
- Firefox
- Safari
- Edge

### ⚠️ Částečně
- Starší prohlížeče
- HTTP (jen HTTPS)

## 🎨 Customizace

### Změnit hlas
```javascript
utterance.pitch = 1.5; // Vyšší hlas
utterance.rate = 0.8;  // Pomalejší
```

### Přidat odpovědi
```javascript
const responses = [
    'Tvoje nová odpověď! 🐉',
    // ...
];
```

### Změnit jazyk
```javascript
recognition.lang = 'en-US'; // Angličtina
utterance.lang = 'en-US';
```

---

🐉 **Užij si povídání se svým dráčkem!** 🎤