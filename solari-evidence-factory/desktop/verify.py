"""Visual QA: open the sandbox preview on a Solari desktop and capture proof."""
import asyncio,os
from pathlib import Path
from solari_desktop import DesktopClient
BASE_URL="https://api.getsolari.com"
async def main():
 preview=Path("artifacts/preview-url.txt").read_text().strip()
 async with DesktopClient(api_key=os.environ["SOLARI_API_KEY"],base_url=BASE_URL) as client:
  desktop=await client.create(template="default",resolution="1280x720",timeout_ms=10*60_000);print(f"[3/3] Desktop: session={desktop.sessionId}\n watch={desktop.streamUrl}")
  try:
   await desktop.connect()
   for _ in range(30):
    health=await desktop.health()
    if getattr(health,"ready",False):break
    await asyncio.sleep(1)
   await desktop.open("google-chrome");await asyncio.sleep(4);await desktop.keyboard.press("CTRL+L");await desktop.keyboard.type(preview);await desktop.keyboard.press("ENTER");await asyncio.sleep(8);shot=await desktop.screenshot(format="png");Path("artifacts/desktop-proof.png").write_bytes(shot);print(f" screenshot=artifacts/desktop-proof.png ({len(shot)} bytes)")
  finally:
   await desktop.close();await client.destroy(desktop.sessionId)
if __name__=="__main__":asyncio.run(main())
