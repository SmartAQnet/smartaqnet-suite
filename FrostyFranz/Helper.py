class Helper:
    Kafkas = {"dev":"http://smartaqnet-dev.teco.edu","kafka-vm0":"http://kafka-vm0.teco.edu"}
    
    Frosts = {"dev":"http://smartaqnet-dev.teco.edu","dev01":"http://smartaqnet-dev01.teco.edu","kafka-vm0":"http://kafka-vm0.teco.edu"}
    
    
    Inst_URL = "edu.teco.wang"
def _getKey(dictionary, rkey, keys):
    for k, v in dictionary.items():
        if isinstance(v, dict):
            nrkey = rkey[:]
            nrkey.append(k)
            _getKey(v, nrkey, keys)
        else:
            if k.find("navigationLink") != -1:

                nrkey = rkey[:]
                nrkey.append(k)
                keys.append(nrkey)
            elif k.find("selfLink") != -1:
                nrkey = rkey[:]
                nrkey.append(k)
                keys.append(nrkey)
def popKeys(dictionary):
    keys = []
    _getKey(dictionary,[], keys)
    rdict = dictionary
    #print(rdict)
    for rkey in keys:
        rdict = dictionary
        #print(rkey)
        for i in range(0, len(rkey)):
            try:
                if i== len(rkey) -1:
                    rdict.pop(rkey[i])
                else:

                    rdict = rdict.get(rkey[i])
            except:
                print(type(rkey[i]), i)
    return dictionary

