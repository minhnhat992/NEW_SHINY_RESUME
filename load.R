load("raw.rda")

#create short chart for kobe
court_img <- "http://robslink.com/SAS/democd54/nba_court_dimensions.jpg"
court <- rasterGrob(readJPEG(getURLContent(court_img)),
                    width=unit(1,"npc"), height=unit(1,"npc"))




