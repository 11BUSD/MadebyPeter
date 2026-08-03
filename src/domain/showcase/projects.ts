export type ShowcaseProject = {
  id: string;
  name: string;
  category: string;
  summary: string;
  status: string;
  boundary: string;
  highlights: string[];
};

export const showcaseProjects: ShowcaseProject[] = [
  {
    id: "vehicle-evidence-network",
    name: "MIRKAB Vehicle Evidence Network",
    category: "Mobility · evidence",
    summary: "A mobile-first, bilingual way to organize a vehicle’s identity, mileage, maintenance, damage, modifications, inspections, and source records into one reviewable history.",
    status: "Synthetic demonstrator",
    boundary: "MIRKAB organizes evidence. It is not a government inspection, certificate, valuation, or warranty.",
    highlights: ["Arabic and English report views", "Reviewable evidence and audit history", "Revocable public vehicle passports"],
  },
  {
    id: "ice-pass",
    name: "Ice Pass",
    category: "Luxury retail · provenance",
    summary: "A configurable evidence, ownership-record, and customer-lifecycle platform for watches, jewellery, handbags, and other high-value items.",
    status: "Independent synthetic concept",
    boundary: "No retailer partnership or endorsement is implied. Demo records are synthetic, and the system is not an authentication authority or title registry.",
    highlights: ["NFC-linked digital item passports", "Private owner vault and service requests", "Human-approved evidence and audit trail"],
  },
];
