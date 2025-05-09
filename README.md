# Directory-Tree-Generator

**Directory-Tree-Generator** is a PowerShell script that generates an interactive, collapsible HTML tree view of the current directory and all its subfolders and files — complete with icons, expandable folders, and file links.

> 📂 Visualise file structures instantly. No installation. No dependencies. Just PowerShell.

---

## 🔧 Features

- Recursively scans the current folder and all subfolders
- Generates a clean, interactive HTML file (`Tree.html`)
- Supports:
  - Folder and file icons (via Font Awesome)
  - Colored icons for common file types (PDF, Word, Excel, etc.)
  - Clickable links to open files or folders
  - Expand/collapse all controls
  - Lightweight and responsive HTML output
- No external dependencies — pure PowerShell + HTML

---

## 🚀 Usage

1. **Download** `Generate-DirectoryTree.ps1`
2. **Open PowerShell** in the folder you want to index
3. **Run:**

```
.\Generate-DirectoryTree.ps1
```

Open the generated Tree.html in your browser.

You can also pass a custom output filename:

```
.\Generate-DirectoryTree.ps1 -OutFile "MyProjectMap.html"
```

## 📝 License
This project is licensed under the MIT License.

You are free to use, modify, and redistribute — just retain the original attribution.

## 🤝 Contributing
Pull requests, feedback, and ideas are welcome.
Feel free to fork the repo or open an issue with enhancements!

