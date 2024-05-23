String.prototype.includes = function (str) {
    return this.search(str) !== -1;
};

Array.prototype.includes = function (str) {
    return this.indexOf(str) !== -1;
};