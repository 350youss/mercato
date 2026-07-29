@echo off
REM ============================================================
REM  Rafraichissement auto des effectifs "Grands Clubs" (hub)
REM  - scrape Transfermarkt -> regenere index.html + equipe.html
REM    directement dans le repo dedie "mercato" (big-clubs-repo)
REM  - publie sur GitHub Pages uniquement si les DONNEES ont change
REM ============================================================
setlocal
set "PUSH=1"
set "REPO=C:\Users\Youss\Documents\big-clubs-repo"
set "SRC=C:\Users\Youss\Documents\animations youtube"

cd /d "%SRC%"
echo [%date% %time%] Scrape grands clubs...
python "scripts\scrape_big_clubs.py"
if errorlevel 1 (
  echo ECHEC du scrape, publication annulee.
  exit /b 1
)

if not "%PUSH%"=="1" goto :done

set "CHANGED=0"
if exist "%REPO%\data\.push" set /p CHANGED=<"%REPO%\data\.push"
if not "%CHANGED%"=="1" (
  echo Donnees inchangees, pas de publication.
  goto :done
)

pushd "%REPO%"
git add equipe.html index.html data\squads.json logos
git commit -m "MAJ grands clubs (auto)"
git push
echo Publie sur GitHub Pages (mercato).
popd

:done
endlocal
