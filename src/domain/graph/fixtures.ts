import type { PublicEdge, PublicGraph, PublicIdea, PublicProfile } from "./model";

export const peter: PublicProfile = { id: "peter", username: "peter", displayName: "Peter", bio: "Exploring how complex systems become understandable ideas." };
export const energyGraph: PublicGraph = { id: "energy-systems", slug: "energy-systems", title: "Energy Systems", description: "A synthetic, public-safe tour through the LNG lifecycle.", owner: peter, rootNodeId: "lng-lifecycle" };

const raw: Array<[string,string,string,PublicIdea["type"]]> = [
  ["lng-lifecycle","LNG Lifecycle","From conditioned gas to grid injection: the connected stages of liquefied natural gas.","system"],
  ["gas-conditioning","Gas conditioning","Preparing feed gas by removing components that interfere with liquefaction.","idea"],
  ["liquefaction","Liquefaction","Cooling natural gas until it becomes a compact transportable liquid.","idea"],
  ["storage","Storage","Holding LNG in insulated tanks while managing heat ingress and pressure.","idea"],
  ["ship-loading","Ship loading","Moving LNG safely from terminal storage into a carrier.","idea"],
  ["custody-transfer","Custody transfer","Measuring transferred energy and quantity at a commercial handoff.","research"],
  ["marine-transport","Marine transport","Carrying LNG between terminals while managing cargo condition.","idea"],
  ["boil-off-gas","Boil-off gas","Vapour created as heat enters a cryogenic cargo system.","idea"],
  ["heel-management","Heel management","Retaining and managing cargo needed to keep tanks cold.","idea"],
  ["reliquefaction","Reliquefaction","Returning boil-off vapour to liquid form aboard a vessel.","idea"],
  ["ship-to-ship-transfer","Ship-to-ship transfer","Transferring LNG between vessels with controlled interfaces.","idea"],
  ["floating-storage","Floating storage","Using a vessel or floating unit as flexible LNG storage.","idea"],
  ["fsru","FSRU","A floating unit that stores LNG and converts it back to gas.","system"],
  ["regasification","Regasification","Warming LNG so it returns to gaseous form for delivery.","idea"],
  ["grid-injection","Grid injection","Delivering conditioned gas into the receiving network.","idea"],
  ["minus-162","−162°C","A synthetic music concept translating cryogenic transformation into sound.","song"],
  ["ship-to-shore","Ship to Shore","A synthetic music concept about the choreography of transfer.","song"],
  ["regas","Regas","A synthetic music concept about returning stored potential to motion.","song"],
];

export const ideas: PublicIdea[] = raw.map(([id,title,summary,type]) => ({
  id,slug:id,graphId:energyGraph.id,title,summary,description:`${summary} This fixture is educational and synthetic; it contains no confidential project data.`,
  type,maturity:type === "system" ? "opportunity" : "concept",creator:peter,publishedAt:"2026-08-02T12:00:00.000Z",branchCount:id === "lng-lifecycle" ? 2 : 0,
  ...(type === "song" ? { media: { provider: "soundcloud" as const, url: "https://soundcloud.com/soundcloud", title: `${title} — illustrative fallback` } } : {}),
  ...(id === "custody-transfer" ? { sources: [{ title:"International Vocabulary of Metrology",url:"https://www.bipm.org/en/committees/jc/jcgm/publications",publisher:"BIPM" }] } : {}),
}));

const edgeRows: Array<[string,string,PublicEdge["relationType"]]> = [
  ["gas-conditioning","lng-lifecycle","part_of"],["liquefaction","lng-lifecycle","part_of"],["storage","lng-lifecycle","part_of"],
  ["ship-loading","lng-lifecycle","part_of"],["marine-transport","lng-lifecycle","part_of"],["floating-storage","lng-lifecycle","part_of"],
  ["fsru","lng-lifecycle","part_of"],["regasification","lng-lifecycle","part_of"],["grid-injection","lng-lifecycle","part_of"],
  ["custody-transfer","ship-loading","requires"],["boil-off-gas","marine-transport","part_of"],["heel-management","marine-transport","part_of"],
  ["reliquefaction","marine-transport","part_of"],["ship-to-ship-transfer","marine-transport","part_of"],["fsru","regasification","enables"],
  ["minus-162","liquefaction","soundtrack_for"],["ship-to-shore","ship-loading","soundtrack_for"],["regas","regasification","soundtrack_for"],
];
export const edges: PublicEdge[] = edgeRows.map(([sourceNodeId,targetNodeId,relationType],index) => ({ id:`edge-${index+1}`,sourceNodeId,targetNodeId,relationType }));
