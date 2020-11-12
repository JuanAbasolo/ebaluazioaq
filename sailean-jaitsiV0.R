###############################################################################
##                                                                            #
## Script name: sailean-jaitsiV0                                              #
##                                                                            #
## Purpose of script: .csv formatuko fitxategi batetik hainbat                #
##                    .etherpad jaisteko                                      #
##                                                                            #
## Author: Juan                                                               #
##                                                                            #
## Date Created: 2020-09-12                                                   #
##                                                                            #
## Email: juan.abasolo@ehu.eus                                                #
##                                                                            #
## Oharrak -----------------------                                            #
##                                                                            #
##     Oinarrizkoa da .csv fitxategian zutabe batek URL izena edukitzea       #
##                                                                            #
##    Inprimakiak-edo erabilita datuak eta etherpad dokumentuak jaistea,      #
##    hurrengo tratamenturako.                                                #
##                                                                            #
##    Honetan ahalegina egiten da google-ko inprimaki bategaz klaseko         #
##    ikasle guztiek egindakoa lantzen                                        #
###############################################################################

## Libreriak ==================================================================
##

require(RCurl)
require(reticulate)

## Datuak =====================================================================
##

## (EGITEKO: elementu bat izan behar da fitxategiaren izena, haxe errepikatzeko)
# x <- '01'
# multzoaren.izena <- x
#
# identifikatzaileak <- read.csv('data/raw/url-zerrendak/paste0(multzoaren.izena, '.csv')',
#                                stringsAsFactors = FALSE)
identifikatzaileak <- read.csv('data/raw/url-zerrendak/<FITXATEGIAREN IXENA>', stringsAsFactors = FALSE)

urlak <- identifikatzaileak$URL

## Fitxategiak jaitsi ---------------------------------------------------------
## Ezaugarri hau ez dauke instantzia batzuetan: ouvaton.coop instantzian ez dauke hori
nun <- regexpr(pattern = "/p/", urlak)

## Kodearen luzera aberiguatu
luze <- nchar(urlak)

## Identifikatu oinarrizko helbideak
oinarrizkoakA <- substr(urlak, 1, nun+2)
oinarrizkoakB <- substr(urlak, nun+3, luze)

hartzeko.etherpadak <- paste(oinarrizkoakA, oinarrizkoakB, '/export/etherpad',sep = '')
hartzeko.txt <- paste(oinarrizkoakA, oinarrizkoakB, '/export/txt',sep = '')

dtk <- data.frame(hartzeko.etherpadak,
                  hartzeko.txt,
                  urlak,
                  oinarrizkoakA,
                  oinarrizkoakB,
                  baja = identifikatzaileak$txtbaja)

## EA DAIBLEN AZTERTZEKO -------------------------------------------------------
## Honek balio behar leuko (ea) karpetak-eta sortzeko

# if(is.na(match('data', list.files()))) dir.create('data')
# if(is.na(match('raw', list.files('data')))) dir.create('data/raw')
# if(is.na(match('etherpad', list.files('data/raw')))) dir.create('data/raw/etherpad')
# if(is.na(match('txt', list.files('data/raw')))) dir.create('data/raw/txt')
# if(is.na(match('multzoaren.izena', list.files('data/raw/etherpad')))) print('Kontuz, aurretik izen hori erabilita')
# stop()

## Dokumentuak jaistea =========================================================
## Hurrengoaren bitartez txt eta etherpad karpetetako azpikarpetetara jaisten da
## Eskuz egin daiteke edo automatizatuta. Komentarioak egokitu behar dira

## Daty hutsetatik garbitu
dtk <- dtk[dtk$urlak != "", ]
dtk <- dtk[dtk$baja=='KK',]

for(i in 1:length(dtk$urlak)){
  print(paste(i, dtk$oinarrizkoakB[i]))
  write(getURL(url = paste0(dtk$urlak[i], '/export/etherpad')),
        file = paste0('data/raw/etherpad/HH-201111-irakebaluazioa/', dtk$oinarrizkoakB[i], '.etherpad'))
  write(getURL(url = paste0(dtk$urlak[i], '/export/txt')),
        # file = paste0('data/raw/txt/', multzoaren.izena, '/', oinarrizkoakB[i], '.txt'))
        file = paste0('data/raw/txt/HH-201111-irakebaluazioa/', dtk$oinarrizkoakB[i], '.txt'))
}

