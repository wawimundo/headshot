var headshotUtils = {
    getPageMetaTags:function () {
        return document.getElementsByTagName('meta');
    },
    getPageMetaValue:function (metaName) {
        var metaValue = '';
        var pageMetaTags = headshotUtils.getPageMetaTags();
        if (pageMetaTags.length > 0) {
            for (var i = 0; i < pageMetaTags.length; i++) {
                if (pageMetaTags[i]['name'] == metaName) {
                    metaValue = pageMetaTags[i]['content'];
                }
            }
        }

        return metaValue;
    }
};

var headshotInitializer = {
    setup: function(width, height, railsTokens) {
        document.write(headshot.get_html(width, height, railsTokens));
    },
    setupHTML: function(width, height, railsTokens) {
        return headshot.get_html(width, height, railsTokens);
    }
};