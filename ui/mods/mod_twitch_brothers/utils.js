String.prototype.includes = function (_str) {
    return this.search(_str) !== -1;
};

Array.prototype.includes = function (_str) {
    return this.indexOf(_str) !== -1;
};