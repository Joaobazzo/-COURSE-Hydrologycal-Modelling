require(XLConnect)
require(stringr)
setwd("/Users/Joao Vieira/Google Drive/TCC/Codigos/")

# ---------------------------------------------
# Lista arquivos
# ---------------------------------------------
dir = "RNAS_RBF/"
lista_est <- list.files(path=paste0(dir,"RAW/ESTACOES/"),pattern = "*.xlsx")
num_est <-  as.character(gsub(".xlsx", "", lista_est, perl=TRUE))
num_est <- num_est[c(-which(num_est=="BALSA_DO_GOIO_ERE"),
                     -which(num_est=="MADEREIRA_GAVAZZONI"),
                     -which(num_est=="GUAMPARA"),
                     -which(num_est=="PONTE_LEONCIO_PRIMO"),
                     -which(num_est=="SALTO_SAPUCAI"))]
#num_est<-c("ETA_GUARAPUAVA")
for (i in (1:length(num_est))){
  # LEITURA DE ARQUIVO
  # ---------------------------------------------
  source_file <- paste0(dir,"RAW/ESTACOES/",num_est[i],".xlsx")
  file <- loadWorkbook(source_file)
  est <- readWorksheet(file,sheet = "plan1")
  # MODELO 3 - P(t),P(t-1),P(t-2),T(t)
  # ---------------------------------------------
  pt <- c(est$THIESSEN,0,0)
  pt1 <- c(0,est$THIESSEN,0)
  pt2 <- c(0,0,est$THIESSEN)
  temp <- c(est$TEMPERATURA,0,0)
  vazao <- c(est$VAZAO,0,0)
  mod3 <- data.frame(pt,pt1,pt2,temp,vazao)
  ext3 <- -c(1,2,dim(mod3)[1]-1,dim(mod3)[1]) #vetor de extremos para exclusão
  mod3 <- round(mod3[ext3,],2)
  dir.create(file.path(paste0(getwd(),"/SIMULACOES/",num_est[i]), "/MODELO_6"), showWarnings = F) # cria subpasta
  output3 <- paste0("SIMULACOES/",num_est[i],"/MODELO_6/input_opera_rbf.txt") # salva input_rbf
  write.table(mod3,output3,sep = "\t",dec=".",row.names = F,col.names = F)
  print(num_est[i])
  
}
