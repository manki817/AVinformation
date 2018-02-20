library("RCurl")
library("XML")
library("stringr")
library("dplyr")
library("downloader")

nameUrl <- "http://www.nanrenvip8.net/find.html"
download.file(url = nameUrl,destfile = "G:/R����/myWorkSpace/AVinfomation/list.html")
namePage <- htmlParse(file = "G:/R����/myWorkSpace/AVinfomation/list.html")
names <- xpathSApply(namePage,
                     str_c('//*[@id="all"]/div[',1:500,']/lable'),
                     xmlValue)
orders <- xpathSApply(namePage,
                      str_c('//*[@id="all"]/div[',1:500,']/div/span[1]'),
                      xmlValue)
orders <- str_extract(orders,"[0-9]{1,3}")
photosUrl <- xpathSApply(namePage,
                         str_c('//*[@id="all"]/div[',1:500,']/a/img'),
                         xmlGetAttr,
                         "data-original")
photos <- getBinaryURL(url = photosUrl)
for (i in 130:length(photosUrl)) {
  if(photosUrl[i] != "http://pic.onemai.com"){
    download(photosUrl[i],str_c("G:/R����/myWorkSpace/AVinfomation/",names[i],".jpg"), mode = "wb")
    print(str_c("��",i,"λŮ�ŵ���Ƭ�������"))
  }
}
listUrl <- xpathSApply(namePage,
                       str_c('//*[@id="all"]/div[',1:500,']/a'),
                       xmlGetAttr,
                       "href")
listUrl <- str_c("http://www.nanrenvip8.net",listUrl)


avImageUrl <- NULL
avFanhao <- NULL
s <- 0
rm(i)
rm(b)
for (c in 1:500) {
  listhtml <- download.file(url = listUrl[c],destfile = str_c("G:/R����/myWorkSpace/AVinfomation/listhtml/",names[c],".html"))
  
}
x <- 0
for (i in 1:500) {
  dir.create(path = str_c("G:/R����/myWorkSpace/AVinfomation/",names[i]))
  #listPage <- htmlParse(getURL(url = listUrl[i],encoding = "utf-8"))
  listPage <- htmlParse(file = str_c("G:/R����/myWorkSpace/AVinfomation/listhtml/",names[i],".html"))
  print(str_c("��",i,"λŮ����Ʒ�б�ҳ�����ز�������ϡ�"))
  a <- 1
  avFanhao <- NULL
  avImageUrl <- NULL

  
  repeat{
    newFanhao <- xpathSApply(listPage,
                             str_c('//*[@id="content"]/li[',a,']/div/span[2]/em/b/a'),
                             xmlValue);

    avFanhao <- c(avFanhao,newFanhao);
    avImageUrl <- c(avImageUrl,
                    xpathSApply(listPage,
                                str_c('//*[@id="content"]/li[',a,']/div/span[1]/a/img'),
                                xmlGetAttr,
                                "data-original"));
    a <- a+1;
    if(is.null(newFanhao))
      break;
  }
  x <- length(avFanhao) + x
  assign(str_c("fanhao",i),avFanhao)
  for (b in 1:length(avFanhao)) {#length(avFanhao)
    ##-------------------------����Ů����Ʒ����ͼƬ------------------
    if(url.exists(avImageUrl[b])){
    download(avImageUrl[b],str_c("G:/R����/myWorkSpace/AVinfomation/",names[i],"/",avFanhao[b],".jpg"), mode = "wb")
    print(str_c("��",i,"/500 λŮ�� ",names[i]," �ĵ� ",b,"/",length(avFanhao)," ����Ʒ ",avFanhao[b]," ����ͼƬ������ϡ�"))
    }else{
      s <- s+1
      print(str_c("��",i,"/500 λŮ�� ",names[i]," �ĵ� ",b,"/",length(avFanhao)," ����Ʒ ",avFanhao[b]," ����ͼƬ����ʧ�ܡ�\n��ǰѭ����ʧ��",s,"��"))
    }
    
    ##----------------------------��������ȡ����A--------------------
    btPage <- htmlParse(getURL(url = str_c("http://www.btanv.com/search/",avFanhao[b],"-hot-desc-1")))
    ciliUrl <- xpathSApply(btPage,
                           str_c('//*[@id="wall"]/div[',1:5,']/div[3]/a[1]'),
                           xmlGetAttr,
                           "href")
    big <- xpathSApply(btPage,
                       str_c('//*[@id="wall"]/div[',1:5,']/div[2]/p/span[3]'),
                       xmlValue)
    ciliInfo <- data.frame(ciliUrl,big)
    ##---------------------------------------------------------------
    
    ##----------------------------��������ȡ����B--------------------
    #cat("\n���ڽ�����ʼ����ҳ�桭��")
    #originalBtListUrl <- htmlParse(getURL(url = str_c("http://www.btdidi.com/search/",avFanhao[b],".html")))
    #btListUrl <- xpathSApply(originalBtListUrl,'//h2/a',xmlGetAttr,"href")
    #btListUrl<- str_replace(btListUrl,".html",'')
    #btListUrl <- str_c("http://www.btdidi.com",btListUrl,"/1-3.html")
    #cat("\n���ڽ�����Դ�б�ҳ�桭��")
    #btListPage <- htmlParse(getURL(url = btListUrl))
    #btPageUrl <- xpathSApply(btListPage,str_c('//*[@id="wall"]/div[',2:6,']/div[1]/h3/a'),xmlGetAttr,"href")
    #btPageUrl <- str_c("http://www.btdidi.com",btPageUrl)
    #cat("\n���ڽ�����Դ����ҳ�桭��")
    #btPage <- htmlParse(getURL(url = btPageUrl))
    #ciliUrl <- xpathSApply(btPage,'//*[@id="wall"]/div[1]/div[1]/div[2]/a',xmlGetAttr,"href")
    ##----------------------------------------------------------------
    write.table(ciliUrl,
                file = str_c("G:/R����/myWorkSpace/AVinfomation/",names[i],"/",
                             avFanhao[b],".txt"),
                sep = "\n\n",
                quote = FALSE,row.names = FALSE, col.names = FALSE)
    print(str_c("��",i,"/500 λŮ�� ",names[i]," �ĵ� ",b,"/",length(avFanhao)," ����Ʒ ",avFanhao[b]," ������������ϡ�"))
  }
}
##500λŮ��
##16837����Ʒ