import {notFound} from "next/navigation";import {env} from "@/lib/env";
export default function Market(){if(env.FEATURE_MARKETPLACE!=="true")notFound();return <main id="main" className="narrow"><h1>Marketplace foundation</h1><p>No listings, checkout, payments, or entitlements are production-ready.</p></main>}
