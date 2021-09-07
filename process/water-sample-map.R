### Load libraries
pacman::p_load(here, dplyr, raster, rgdal, rnaturalearth, ggplot2, ggthemes, ggspatial, sf)

## Create hillshade map layer----
## load hillshade Rdata if available and up to date (rather than create new hillshade layer from SRTM)

### Download and process SRTM
dem.02035 <- getData("SRTM", lon=35, lat=2)
dem.02036 <- getData("SRTM", lon=36, lat=2)
dem.02037 <- getData("SRTM", lon=37, lat=2)
dem.03035 <- getData("SRTM", lon=35, lat=3)
dem.03036 <- getData("SRTM", lon=36, lat=3)
dem.03037 <- getData("SRTM", lon=37, lat=3)
dem.04035 <- getData("SRTM", lon=35, lat=4)
dem.04036 <- getData("SRTM", lon=36, lat=4)
dem.04037 <- getData("SRTM", lon=37, lat=4)
dem.05035 <- getData("SRTM", lon=35, lat=5)
dem.05036 <- getData("SRTM", lon=36, lat=5)
dem.05037 <- getData("SRTM", lon=37, lat=5)
dem.06035 <- getData("SRTM", lon=35, lat=6)
dem.06036 <- getData("SRTM", lon=36, lat=6)
dem.06037 <- getData("SRTM", lon=37, lat=6)
dem.grid <- mosaic(dem.02035, dem.02036, dem.02037, dem.03035, dem.03036, dem.03037, dem.04035, dem.04036, dem.04037, dem.05035, dem.05036, dem.05037, dem.06035, dem.06036, dem.06037, fun=mean)

### Generate hillshade layer
slope <- terrain(dem.grid, opt = "slope")
aspect <- terrain(dem.grid, opt = "aspect")
hill <- hillShade(slope, aspect, angle = 45, direction = 300)
plot(hill, col = rev(colorRampPalette(c("white", "black"))(100)))

### Compress and convert
hill.shrink <- aggregate(hill, fact = 4)
hill.raster <- rasterToPoints(hill.shrink)
hillshade <- as.data.frame(hill.raster)
saveRDS(hillshade, "data/Turkana-hillshade.Rdata")

## Load assets and data----

hillshade <- readRDS("data/Turkana-hillshade.Rdata")
rivers <- readRDS("data/rivers.Rdata")
rivers <- rivers |> filter(long < 36.5)
# Africa Rivers. (2014). World Agroforestry Centre. Retrieved from http://landscapeportal.org/layers/geonode:africa_rivers_1
Kerio <- readRDS("data/KerioRiver.Rdata")
# freehand .kml from Google Earth traced path
lakes <- readRDS("data/lakes.Rdata")
# re-download using Natural Earth syntax before submission
Africa.borders <- ne_countries(continent = 'africa', returnclass = "sf")
# Made with Natural Earth. Free vector and raster map data @ naturalearthdata.com.

waters.data <- read.csv("data/2016-2020_waters.csv")

### Draw map----

## Define theme
theme_set(theme_classic(base_family = "Helvetica", base_size = 16))
water.color <- "darkcyan"
fill.color <- "gray95"
point.size <- 3

## Define sample type shapes
shape.lake <- 16 # circle
shape.precip <- 17 # triangle
shape.river <- 15 # square
shape.ground.deep <- 7 # x in box
shape.ground.shallow <- 4 # x
shape.surface.evap <- 5 # diamond empty
shape.surface.lake <- 1 # circle empty

## Define map limits
lim.TBN <- 5
lim.TBS <- 2.3
lim.TBE <- 36.7
lim.TBW <- 35.4

## Regional map
Turkana.map <- ggplot() +
  geom_tile(data = hillshade, aes(x = x, y = y, fill = layer)) +
  scale_fill_distiller(palette = "Greys", direction = -1, guide = "none") +
  geom_sf(data = Africa.borders, fill = NA, linetype = 2) +
  # the following polygon is from a possibly deprecated Natural Earth download (see notes above)
  geom_polygon(data = lakes |>
                 filter(id == 1300), # arbitrary ID for Lake Turkana
               aes(x = long, y = lat, group = group), fill = water.color, color = "gray30") +
  geom_path(data = rivers, aes(x = long, y = lat, group = group), color = water.color) +
  geom_sf(data = Kerio, color = water.color) +
  geom_point(data = waters.data |>
               filter(WaterType != "Evaporated Surface"), # remove less relevant points crowding Ileret
             aes(x = Longitude, y = Latitude, shape = WaterType), size = point.size) +

  # legend
  scale_shape_manual(
    breaks = c("Lake", "River", "Precipitation", "Restricted Lake", "Shallow Ground", "Deep Ground"),
    values = c(
      "Lake" = shape.lake,
      "River" = shape.river,
      "Precipitation" = shape.precip,
      "Restricted Lake" = shape.surface.lake,
      "Shallow Ground" = shape.ground.shallow,
      "Deep Ground" = shape.ground.deep)) +

  annotation_scale() +
  annotation_north_arrow(location = "tr", which_north = "true",
                         style = north_arrow_fancy_orienteering) +
  coord_sf(xlim = c(lim.TBW, lim.TBE), ylim = c(lim.TBS, lim.TBN)) +
  scale_x_continuous(breaks = c(35.5, 36, 36.5)) +
  labs(shape = "Water sample type",
       x = NULL, y = NULL)
plot(Turkana.map)

Turkana.map.zoom <- Turkana.map +
  coord_sf(xlim = c(36, 36.5), ylim = c(3.7, 4.5))
plot(Turkana.map.zoom)
