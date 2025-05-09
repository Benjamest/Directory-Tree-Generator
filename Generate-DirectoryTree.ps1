<#
.SYNOPSIS
  Generate an HTML directory tree of the current folder and all subfolders.

.DESCRIPTION
  Scans the current directory recursively, builds a nested UL/LI tree,
  embeds Font Awesome icons, and writes out Tree.html with expand/collapse support.
  Includes improved CSS for spacing, guide lines, and colored file‐type icons.

.PARAMETER OutFile
  Name of the HTML file to generate (default: Tree.html).

.EXAMPLE
  .\Generate-DirectoryTree.ps1
#>

[CmdletBinding()]
Param(
    [string]$OutFile = "Tree.html"
)

# Map file extensions to Font Awesome icons with type-specific CSS classes
$fileTypeIcons = @{
    '.txt'   = '<i class="fa-regular fa-file-lines"></i>'
    '.pdf'   = '<i class="fa-regular fa-file-pdf icon-pdf"></i>'
    '.doc'   = '<i class="fa-regular fa-file-word icon-word"></i>'
    '.docx'  = '<i class="fa-regular fa-file-word icon-word"></i>'
    '.xls'   = '<i class="fa-regular fa-file-excel icon-excel"></i>'
    '.xlsx'  = '<i class="fa-regular fa-file-excel icon-excel"></i>'
    '.ppt'   = '<i class="fa-regular fa-file-powerpoint icon-powerpoint"></i>'
    '.pptx'  = '<i class="fa-regular fa-file-powerpoint icon-powerpoint"></i>'
    '.jpg'   = '<i class="fa-regular fa-file-image icon-image"></i>'
    '.jpeg'  = '<i class="fa-regular fa-file-image icon-image"></i>'
    '.png'   = '<i class="fa-regular fa-file-image icon-image"></i>'
    '.gif'   = '<i class="fa-regular fa-file-image icon-image"></i>'
    '.mp3'   = '<i class="fa-regular fa-file-audio icon-audio"></i>'
    '.wav'   = '<i class="fa-regular fa-file-audio icon-audio"></i>'
    '.zip'   = '<i class="fa-regular fa-file-zipper icon-zip"></i>'
    '.rar'   = '<i class="fa-regular fa-file-zipper icon-zip"></i>'
}

function Get-TreeHtml {
    param([string]$Path)

    # Retrieve directories first, then files
    $items = Get-ChildItem -LiteralPath $Path | Sort-Object @{Expression = {!$_.PsIsContainer}}, Name

    foreach ($item in $items) {
        if ($item.PsIsContainer) {
            # Folder node with two icons for closed/open states
            @"
<li>
  <span class="caret">
    <i class="fa-solid fa-folder"></i>
    $($item.Name)
  </span>
  <ul class="nested">
    $(Get-TreeHtml -Path $item.FullName)
  </ul>
</li>
"@
        } else {
            # File node, default icon if extension not mapped
            $ext  = $item.Extension.ToLower()
            $icon = if ($fileTypeIcons.ContainsKey($ext)) { $fileTypeIcons[$ext] } else { '<i class="fa-regular fa-file"></i>' }
            @"
<li class="file">
  $icon <a href='file:///$($item.FullName)'>$($item.Name)</a>
</li>
"@
        }
    }
}

# Build HTML content
$html = @"
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Directory Tree: $(Get-Location)</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <style>
    /* Container & font */
    body {
      font-family: "Segoe UI", Tahoma, sans-serif;
      font-size: 14px;
      margin: 20px;
      background: #f5f7fa;
    }
    #fileTree {
      border: 1px solid #ddd;
      border-radius: 6px;
      padding: 12px;
      background: #fff;
    }

    /* Reset lists */
    #fileTree, #fileTree ul {
      list-style: none;
      margin: 0;
      padding: 0;
    }

    /* Guide lines */
    #fileTree ul.nested {
	  display: none;
      margin-left: 1em;
      padding-left: 1em;
      border-left: 1px solid #e0e0e0;
    }
	#fileTree ul.nested.active {
      display: block;
    }
    #fileTree li {
      position: relative;
      margin: 4px 0;
      line-height: 1.4;
    }
    #fileTree li::before {
      content: "";
      position: absolute;
      top: 0.9em;
      left: -1em;
      width: 1em;
      height: 1px;
      background: #e0e0e0;
    }

    /* Folder toggle */
    .caret {
	  cursor: pointer;
	  user-select: none;
	  display: inline-flex;
	  align-items: center;
	}
	.caret i.fa-folder {
	  margin-right: 0.4em;
	  color: #f1c40f;
	}

    /* File links */
    li.file a {
      text-decoration: none;
      color: #0366d6;
      margin-left: 1.8em;
    }
    li.file a:hover {
      text-decoration: underline;
    }

    /* File-type icon colors */
    .icon-pdf        { color: #c0392b; }
    .icon-word       { color: #2980b9; }
    .icon-excel      { color: #27ae60; }
    .icon-powerpoint { color: #d35400; }
    .icon-image      { color: #8e44ad; }
    .icon-audio      { color: #16a085; }
    .icon-zip        { color: #f39c12; }

    /* Controls */
    #controls {
      margin-bottom: 12px;
    }
    #controls button {
      background: #fff;
      border: 1px solid #ccc;
      border-radius: 4px;
      padding: 6px 10px;
      margin-right: 6px;
      cursor: pointer;
      font-size: 13px;
    }
    #controls button:hover {
      background: #f0f0f0;
    }
  </style>
</head>
<body>
  <h2>Directory Tree: $(Get-Location)</h2>
  <div id="controls">
    <button id="expandAll">Expand All</button>
    <button id="collapseAll">Collapse All</button>
  </div>
  <ul id="fileTree">
    $(Get-TreeHtml -Path (Get-Location))
  </ul>

  <script>
    document.addEventListener('DOMContentLoaded', () => {
      const togglers = document.getElementsByClassName('caret');
      for (let t of togglers) {
        t.addEventListener('click', () => {
          const nested = t.parentElement.querySelector('.nested');
          nested.classList.toggle('active');
          t.classList.toggle('caret-down');
        });
      }

      document.getElementById('expandAll').addEventListener('click', () => {
        document.querySelectorAll('.nested').forEach(n => n.classList.add('active'));
        document.querySelectorAll('.caret').forEach(c => c.classList.add('caret-down'));
      });

      document.getElementById('collapseAll').addEventListener('click', () => {
        document.querySelectorAll('.nested').forEach(n => n.classList.remove('active'));
        document.querySelectorAll('.caret').forEach(c => c.classList.remove('caret-down'));
      });
    });
  </script>
</body>
</html>
"@

# Output HTML file
$html | Out-File -FilePath $OutFile -Encoding UTF8

Write-Host "HTML directory tree generated: $OutFile"
