Na spustenie treba
- MATLAB R20XX alebo novší
- Parallel toolbox

Pre Autonómne vozidlo treba taktiež
- Navigation toolbox


Na spustenie učenia treba spustiť script
Obidve aplikácie obsahujú:
- skript ucenie_vsetko.m, ktorý spustí učenie jednotlivých evolučných algoritmov a uloží naučené údaje
- skript zrob_grafy.m ktorý podľa zadefinovaných názvov načíta jednotlivé súbory s naučenými neurónovými sieťami, pre ktoré následne vygeneruje grafy

Autonómne vozidlo následne obsahuje ešte
- funkciu simulate_run.m pomocou ktorej viete zobraziť simuláciu pre danú sieť

Autonómne vozidlo sa odráža od projektu https://github.com/AlesMel/Neuro-evolution-BP, ktorý sme následne upravili pre naše potreby.