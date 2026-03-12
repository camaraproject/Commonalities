# GeoJSON Geometry Model (Optional) – Commonalities Guidance

This document introduces an **optional GeoJSON (RFC 7946)** geometry model for CAMARA APIs that require spatial comparison or GIS-native capabilities.

The intention is **not** to replace the existing CAMARA `Area` datatype, but to provide an additional model when needed, 
without impacting existing and future CAMARA APIs that only require simple Circle or Polygon structures.

---

## 1. Motivation

Some CAMARA APIs currently perform **geometric comparisons**, such as:

- checking containment (within)
- checking intersection / overlap
- computing an intersection area
- determining coverage relationships

These are best handled using **GIS-native geometry models**, which already exist in spatial databases and GIS engines.

The current CAMARA `Area` model (Circle / Polygon using custom JSON) is sufficient for *simple* APIs that only **return** an area.  
However, APIs performing **spatial predicates** benefit from using a standard format.

---

## 2. Proposal

Introduce an **optional** geometry type:
```json
GeoJSONGeometry:
type: object
description: RFC 7946 GeoJSON geometry object
```

---

APIs MAY choose whether to use:

- **CAMARA `Area` (Circle/Polygon)** → for simple location-returning APIs  
- **`GeoJSONGeometry`** → for APIs requiring spatial search, geometric comparisons, or integration with GIS engines

This proposal:
- does **not** require any existing API to change  
- does **not** mandate a `oneOf` with both models  
- keeps Area/Circle/Polygon fully valid
- lets each API initiative decide independently which model is appropriate.

---
## 3. Why Optional GeoJSON?

### 3.1 CAMARA principles
CAMARA aims to provide **simple, developer-friendly APIs**.  
Many APIs do not need full GIS capability, and forcing GeoJSON adoption would add
unnecessary complexity.

### 3.2 When to use CAMARA Area
Use the existing `Area` / `Circle` / `Polygon` types when an API only needs to:

- return a device location area  
- represent coarse-grained coverage  
- pass a simple geometric boundary without geometric computations  

### 3.3 When GeoJSON helps
Use GeoJSON when an API must perform:

- overlap detection
- containment verification
- geometric search among multiple areas
- distance or coverage evaluation
- spatial indexing through GIS engines

GeoJSON aligns with existing mature stacks such as PostGIS, Oracle Spatial,
SQL Server Geography, GeoServer, Elasticsearch, MongoDB, and others.

---

## 4. Circles in GeoJSON

GeoJSON does not define a `Circle` type, consistent with GIS industry practice.
Common approaches include:

- **Polygon approximation** (recommended and universally supported)
- **Feature(Point) + radius** as a convenience input extension
- Optional `"type": "Circle"` as a non-standard hint, internally converted to polygon

All approaches result in a Polygon for authoritative spatial operations.

---

## 5. API Design Guidance

To avoid fragmentation and keep APIs simple, the following guidance is recommended:

- **Simple APIs**  
  (that only *return* an area)  
  → SHOULD use the existing CAMARA `Area` datatype.

- **APIs requiring geometric comparison**  
  (containment, overlap, match rate, coverage, spatial search)  
  → SHOULD consider using the optional `GeoJSONGeometry` datatype.

- **Each API initiative remains autonomous**  
  No API is required to support both models.  
  API designers choose the most suitable model for their scenario.

---

## 6. Summary

This proposal provides:

- a **non-breaking**, optional extension  
- better support for APIs with spatial logic  
- reuse of GIS-native capabilities  
- continued simplicity for basic APIs  
- a unified geometry model across CAMARA when spatial search is needed

No changes are required in existing API definitions unless they choose to adopt GeoJSON.
