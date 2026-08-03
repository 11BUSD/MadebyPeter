import type { Metadata } from "next";
import { SiteHeader } from "@/components/site-header";
import { MobileNav } from "@/components/mobile-nav";
import "./globals.css";

export const metadata: Metadata = { title:{default:"Made by Peter — Ideas that grow",template:"%s — Made by Peter"},description:"A branchable public record of ideas and execution.",metadataBase:new URL(process.env.NEXT_PUBLIC_SITE_URL||"http://localhost:3000") };
export default function RootLayout({children}:{children:React.ReactNode}) {return <html lang="en" data-scroll-behavior="smooth"><body><a className="skip-link" href="#main">Skip to content</a><SiteHeader/>{children}<footer>Made by Peter · Ideas keep their roots.</footer><MobileNav/></body></html>}
