#!/usr/bin/env python3
"""
Debug tool pro testování GitHub Pages
Kontroluje dostupnost URL, dělá screenshoty a analyzuje obsah
"""

import requests
import time
import json
from datetime import datetime
import subprocess
import sys
import os

class GitHubPagesDebugger:
    def __init__(self, base_url="https://mdoomapplications.github.io/AndroidGame"):
        self.base_url = base_url
        self.session = requests.Session()
        self.session.headers.update({
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
        })
    
    def test_url(self, path=""):
        """Testuje URL a vrací informace o odpovědi"""
        url = f"{self.base_url}/{path}".rstrip('/')
        if not path:
            url = self.base_url
            
        print(f"\n🔍 Testování: {url}")
        
        try:
            response = self.session.get(url, timeout=10, allow_redirects=True)
            
            result = {
                "url": url,
                "status_code": response.status_code,
                "content_type": response.headers.get("content-type", ""),
                "content_length": len(response.content),
                "redirects": len(response.history),
                "final_url": response.url,
                "success": response.status_code == 200
            }
            
            # Kontrola redirectů
            if response.history:
                print(f"  📍 Redirecty: {len(response.history)}")
                for i, redirect in enumerate(response.history):
                    print(f"    {i+1}. {redirect.status_code} → {redirect.url}")
                print(f"  🎯 Finální URL: {response.url}")
            
            if response.status_code == 200:
                print(f"  ✅ Status: {response.status_code}")
                print(f"  📄 Content-Type: {response.headers.get('content-type', 'N/A')}")
                print(f"  📏 Velikost: {len(response.content)} bytes")
                
                # Kontrola obsahu
                content = response.text.lower()
                
                # Detekce typu obsahu
                if "dragon tamagotchi" in content:
                    print("  🐉 Obsahuje 'Dragon Tamagotchi' ✅")
                
                if len(response.content) > 15000:
                    print("  📦 Velký obsah (>15KB) - pravděpodobně kompletní hra ✅")
                elif len(response.content) > 5000:
                    print("  📦 Střední obsah (5-15KB) - částečná hra ⚠️")
                else:
                    print("  📦 Malý obsah (<5KB) - možná chyba ❌")
                
                if "function startgame" in content or "function start" in content:
                    print("  🎮 Obsahuje herní funkce ✅")
                
                if "vytvořit dráčka" in content:
                    print("  🥚 Obsahuje herní text ✅")
                
                if "načítání hry" in content:
                    print("  ⚠️ Starý Flutter wrapper detekován!")
                
                if "@media" in content:
                    print("  📱 Responzivní design ✅")
                
                if "<script" in content:
                    print("  📜 Obsahuje JavaScript ✅")
                    
                # Uložení obsahu pro analýzu
                filename = f"debug_content_{path.replace('/', '_') if path else 'root'}.html"
                with open(filename, 'w', encoding='utf-8') as f:
                    f.write(response.text)
                print(f"  💾 Obsah uložen: {filename}")
                
            else:
                print(f"  ❌ Status: {response.status_code}")
                if response.status_code == 404:
                    print("  🚫 Soubor nenalezen")
                elif response.status_code >= 500:
                    print("  🔥 Chyba serveru")
                    
            return result
            
        except requests.exceptions.Timeout:
            print("  ⏰ Timeout - stránka se nenačetla včas")
            return {"url": url, "error": "timeout"}
        except requests.exceptions.ConnectionError:
            print("  🔌 Chyba připojení")
            return {"url": url, "error": "connection_error"}
        except Exception as e:
            print(f"  💥 Neočekávaná chyba: {e}")
            return {"url": url, "error": str(e)}
    
    def analyze_results(self, results):
        """Analyzuje výsledky testů"""
        print("\n📊 ANALÝZA VÝSLEDKŮ:")
        print("=" * 50)
        
        working_pages = [r for r in results if r.get("success")]
        broken_pages = [r for r in results if not r.get("success")]
        
        print(f"✅ Fungující stránky: {len(working_pages)}")
        for page in working_pages:
            print(f"  • {page['url']} ({page['content_length']} bytes)")
        
        print(f"\n❌ Nefungující stránky: {len(broken_pages)}")
        for page in broken_pages:
            error = page.get('error', f"HTTP {page.get('status_code', 'unknown')}")
            print(f"  • {page['url']} - {error}")
        
        # Kontrola redirectů
        redirected = [r for r in results if r.get("redirects", 0) > 0]
        if redirected:
            print(f"\n🔄 Stránky s redirecty: {len(redirected)}")
            for page in redirected:
                print(f"  • {page['url']} → {page.get('final_url')}")
        
        # Hodnocení
        print(f"\n🎯 HODNOCENÍ:")
        if len(working_pages) > 0:
            main_page = working_pages[0]
            if main_page['content_length'] > 15000:
                print("✅ EXCELENTNÍ - Velká kompletní hra je online!")
            elif main_page['content_length'] > 5000:
                print("⚠️ DOBRÉ - Hra je online, ale možná neúplná")
            else:
                print("❌ PROBLÉM - Obsah je příliš malý")
        else:
            print("❌ KRITICKÉ - Žádná stránka nefunguje")

def main():
    print("🐉 GitHub Pages Debug Tool 🐉")
    print("=" * 40)
    
    debugger = GitHubPagesDebugger()
    
    # Test hlavní stránky
    print("🚀 Testování hlavní stránky...")
    results = [debugger.test_url()]
    
    # Analýza
    debugger.analyze_results(results)
    
    # Uložení výsledků
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    report_file = f"debug_report_{timestamp}.json"
    with open(report_file, 'w') as f:
        json.dump(results, f, indent=2)
    
    print(f"\n💾 Report uložen: {report_file}")
    
    # Finální doporučení
    print("\n🎯 DOPORUČENÍ:")
    if results[0].get("success") and results[0].get("content_length", 0) > 15000:
        print("✅ Vše funguje perfektně! HTML verze je online.")
    elif results[0].get("success"):
        print("⚠️ Stránka funguje, ale obsah může být neúplný.")
    else:
        print("❌ Stránka nefunguje - zkontroluj GitHub Pages nastavení.")

if __name__ == "__main__":
    main()