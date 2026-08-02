"use client";
import dynamic from "next/dynamic";
import type {Neighborhood} from "@/domain/graph/model";
const MapCanvas=dynamic(()=>import("./map-canvas").then((mod)=>mod.MapCanvas),{ssr:false,loading:()=> <div className="map-loading" role="status">Preparing the map… Story view remains available.</div>});
export function MapLoader({graphSlug,initial}:{graphSlug:string;initial:Neighborhood}){return <MapCanvas graphSlug={graphSlug} initial={initial}/>}
