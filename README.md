# 🎬 Movies_MovieNameSanitiser.ps1

> **Sanitise your Movie filenames for optimal media scraping.**  
> Rename movie files to a consistent, clean format ready for JellyFin, Plex, or other media libraries.

---

## 📁 Purpose

`Movies_MovieNameSanitiser.ps1` is a PowerShell script designed to recursively scan a specified movie directory, identify inconsistently named movie files, and convert them into a clean, structured format:


This helps improve compatibility with scrapers used by media servers like JellyFin and Plex, reducing mismatches and improving library accuracy.

---

## ⚙️ Features

- ✅ Recursively scans directories
- ✅ Renames files into the format: `Movie Title (Year).ext`
- ✅ Ignores already compliant files
- ✅ Logs unmatched or ambiguous entries
- ✅ **Safe Mode**: Preview changes without renaming (default)

---

## 🔧 Usage

### 1. Configure the target directory

Open the script and set the `$rootMovies` variable:

```powershell
$rootMovies = "\\192.168.1.184\movies\Movies"
