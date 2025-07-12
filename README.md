# Catercolor 🎨🐛

Catercolor is a fun and interactive iOS/iPadOS/macOS app designed to help assess **color vision abilities in children** through an engaging drag-and-drop game.

Players drag colored balls to the correct caterpillar and build up caterpillar segments — the app tracks correct and incorrect matches, calculates potential color vision deficiencies, and generates a downloadable PDF report.

---

## ✨ Features

- 🐛 **Drag & Drop Gameplay:**  
  Drag colored balls onto matching caterpillars; add colorful segments to each caterpillar.

- ⏱ **Timed Challenge:**  
  Complete as many correct matches as you can in 180 seconds.

- 📊 **Results Tracking:**  
  Counts correct/incorrect matches per color.

- 🧪 **Vision Analysis:**  
  Warns if there are signs of color vision deficiency (e.g., red-green or blue-yellow).

- 📝 **PDF Report Generation:**  
  Exports a beautiful PDF summary with the child’s name, age, date, caterpillar snapshots, and results.

- 💻 **Cross-device Compatible:**  
  Works on Mac, iPad, and iPhone, with optimized drag-and-drop on each.

---

## 🖼 Interface Preview

### Start Screen
<p align="center">
  <img src="Catercolor/screenshots/start_screen.png" width="50%">
</p>

---

### Gameplay Screen
<p align="center">
  <img src="Catercolor/screenshots/gameplay_screen.png" width="50%">
</p>

---

### Summary Screen
<p align="center">
  <img src="Catercolor/screenshots/summary_screen.png" width="50%">
</p>

---

### PDF Report Example
<p align="center">
  <img src="Catercolor/screenshots/pdf_report.png" width="50%">
</p>

---

## 🚀 How to Run

1️⃣ Clone the repository:
```bash
git clone https://github.com/jenxwa/Catercolor.git
````

2️⃣ Open in Xcode:

```
open Catercolor.xcodeproj
```

3️⃣ Build & run on:

* iPhone simulator / iPad simulator
* Mac (Mac Catalyst target)

---

## ⚙️ Dependencies

✅ Pure SwiftUI
✅ Uses built-in **UIGraphicsPDFRenderer** for PDF export on iOS
✅ No external libraries needed

---

## 📂 Project Structure

* `ContentView.swift` → Main game logic and UI
* `Models.swift` → Data models: Caterpillar, Segment, Ball, etc.
* `PDFExporter.swift` → Cross-platform PDF export extension
* `ReportView.swift` → Report view layout used for PDF generation

---

## 🏥 Disclaimer

This app is **for educational and entertainment purposes only.**
It is **not a medical diagnostic tool**. If you suspect a child has a color vision deficiency, please consult a healthcare professional.

---

## 💛 Created by

Jennifer Warbeck — July 2025

This project and its contents are the intellectual property of the repository owner.
Copying, redistributing, or using this project (or parts of it) without explicit permission is not allowed.
All rights reserved.

If you are interested in using or building upon this project, please contact me to discuss licensing or collaboration.
