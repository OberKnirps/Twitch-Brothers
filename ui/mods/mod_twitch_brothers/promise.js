var tmi_Promise = function(fn) {
    var state = 'pending';
    var callbacks = [];
    var result = null;
    function res_rej(a,b,c) {
        if(state !== 'pending'){
            return;
        }
        if(b && b['then'] && typeof b['then'] === 'function'){
            b['then'](resolve, reject);
            return;
        }
        state = a;
        result = b;
        callbacks.forEach(function (obj) {
            obj[c](result);
        });
    }
    function resolve(value) {
        res_rej('fulfilled',value,0);
    }
    function reject(reason) {
        res_rej('rejected',reason,1);
    }
    this.then = function (onFulfilled,onRejected) {
        return new tmi_Promise(function (resolve, reject) {
            switch (state){
                case 'pending':
                    callbacks.push([
                        function () {
                            if(typeof onFulfilled === 'function'){
                                try {
                                    resolve(onFulfilled(result));
                                } catch (ex) {
                                    reject(ex);
                                }
                            }
                            else{
                                resolve(result);
                            }
                        },
                        function () {
                            if(typeof onRejected === 'function'){
                                try {
                                    reject(onRejected(result));
                                } catch (ex) {
                                    reject(ex);
                                }
                            }
                            else{
                                reject(result);
                            }
                        }
                    ]);
                    break;
                case 'fulfilled':
                    resolve(onFulfilled(result));
                    break;
                case 'rejected':
                    reject(onRejected(result));
                    break;
            }
        });
    };
    this.catch = function (onRejected) {
        return this.then(null, onRejected);
    };
    fn(resolve,reject);
};

tmi_Promise.resolve = function (value) {
    return new tmi_Promise(function(resolve) {
        resolve(value);
    });
};

tmi_Promise.reject = function (reason) {
    return new tmi_Promise(function(resolve, reject) {
        reject(reason);
    });
};

tmi_Promise.all = function (tmi_Promises) {
    return new tmi_Promise(function(resolve, reject) {
        var count = 0;
        var values = [];
        for (var i = 0; i < tmi_Promises.length; i++) {
            tmi_Promise.resolve(tmi_Promises[i]).then(function(value) {
                values.push(value);
                if (count === tmi_Promises.length-1) {
                    resolve(values);
                }
                else{
                    count++;
                }
            }, function(reason) {
                reject(reason);
            });
        }
    });
};

tmi_Promise.race = function (tmi_Promises) {
    return new tmi_Promise(function(resolve, reject) {
        for (var i = 0; i < tmi_Promises.length; i++) {
            tmi_Promise.resolve(tmi_Promises[i]).then(function(value) {
                resolve(value);
            }, function(reason) {
                reject(reason);
            })
        }
    });
};
