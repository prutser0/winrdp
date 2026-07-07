# RDP Wrapper — Remote Desktop voor Windows Home

🇳🇱 **Schakel Remote Desktop (RDP + meerdere sessies) in op Windows 11/10 Home — zonder Pro licentie.**

🇬🇧 **Enable Remote Desktop (RDP + multi-session) on Windows 11/10 Home — no Pro license needed.**

---

## ✨ Wat het doet / What it does

- **Remote Desktop Server** — Windows Home heeft geen RDP-server. Deze wrapper voegt hem toe.
- **Multiple sessions** — meerdere gebruikers tegelijk inloggen (ideaal voor thuiswerken / labs).
- **Gebruikt de native Microsoft Remote Desktop client** op Mac, Windows, iPad, Android — geen extra software.

## 🚀 Installatie

### Snel (één commando)

**PowerShell (als Administrator):**

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
irm https://raw.githubusercontent.com/<jouw-org>/rdp-wrap/main/install.ps1 | iex
```

### Handmatig

1. **Download** de nieuwste [RDP Wrapper v1.6.2](https://github.com/stascorp/rdpwrap/releases)
2. **Kopieer** `rdpwrap.ini` naar `C:\Program Files\RDP Wrapper\`
3. **Voer uit** als Administrator:
   ```cmd
   RDPWInst.exe -i
   net stop TermService && net start TermService
   ```
4. **Controleer** met `RDPConf.exe` — alles moet groen zijn
5. **Firewall** controle: `netsh advfirewall firewall show rule name="Remote Desktop"`

### 🍎 Vanaf je Mac verbinden

1. Installeer **Microsoft Remote Desktop** (gratis) uit de Mac App Store
2. Voeg een nieuwe PC toe met het IP-adres van deze Windows PC
3. Log in met je Windows-gebruikersnaam en wachtwoord

## 📋 Bestanden / Files

| Bestand | Doel |
|---------|------|
| `rdpwrap.ini` | Configuratie — community-maintained, ondersteunt de nieuwste Windows builds |
| `install.ps1` | PowerShell installatiescript (downloadt RDP Wrapper + past ini toe) |
| `install.bat` | Batch installatiescript (alternatief) |
| `LICENSE` | Licentie |

## 📌 Opmerkingen / Notes

- **RDP Wrapper Library** is gemaakt door [Stas'M Corp.](https://github.com/stascorp/rdpwrap) — BSD-licensed.
- De `rdpwrap.ini` wordt onderhouden door [sebaxakerhtc](https://github.com/sebaxakerhtc/rdpwrap.ini).
- Bij een Windows Update kan het zijn dat de ini niet meer werkt — download dan de nieuwste versie van bovenstaande repo.

## ⚠️ Disclaimer

Dit project is een **configuratieverzameling** rond RDP Wrapper Library. Gebruik op eigen risico. Dit maakt Windows Home geen gelicenseerde Pro-versie — het ontgrendelt alleen technische mogelijkheden die Microsoft heeft geblokkeerd in de Home-editie.
