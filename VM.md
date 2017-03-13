SSH: 
```
ssh -CAXY llj.lilingjie.brc@brain.megvii-inc.com
```

Internal DNS: 
```
llj.lilingjie.brc.sm.megvii-op.org
```

HTTP Proxy: 
```
export all_proxy=http://proxy.i.brainpp.ml:3128 no_proxy=.i.brainpp.ml,.brain.megvii-inc.com,.sm.megvii-op.org,127.0.0.1,localhost; export http_proxy=$all_proxy https_proxy=$all_proxy
```
(Use this if you want internet access inside Brain++.)