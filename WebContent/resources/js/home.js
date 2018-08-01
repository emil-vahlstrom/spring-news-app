console.log("Loaded home.js");

$(document).ready(function() {
    
//    var test = "test";
//    if (path == undefined) {
//        console.log("path is undefined")
//        var path = 'http://localhost:8080/SpringNewsApp/';
//    }
    
    var nextPage, principal;
    
    init();
    
    function init() {
        console.log("in init");
        
        nextPage = 1; //start count from 0
        principal = "";
        
        getPrincipal();
    }
    
    console.log("path is: " + path)
    
    if (path == undefined) {
        console.log("path is undefined, changing path");
        path = "http://localhost:8080/SpringNewsApp/";
    }
    
    $('#loadNewsButton').on('click', function(event) {

        var settings = {
            url: path + '/news',
            dataType: 'json',
            contentType: 'application/json',
            data: { page: nextPage },
            success: function(data) {
                
                if (data == undefined) {
                    return;
                }
                
                checkVars = data;
                
                nextPage++;
                data.forEach(function(news) {
                    console.log(news.headline);
                    var d = new Date(news.created);
                    news.created = d.getFullYear() + '-' + ( '0' + (d.getMonth() + 1)).slice(-2) + '-' + ('0' + d.getDate()).slice(-2);
                    
                    var htmlString = '';
                    htmlString += '<div class="news-item row no-gutters">\n';
                    
                    var thumb = null;
                    
                    news.newsImageHeads.forEach(function(head, index) {
                        if (head.thumbnail == false) {
                            htmlString += '<div class="p-sm-2px col-' + head.size + (index > 0 ? ' pl-2px' : '') +'">\n' +
                                '<img class="news-head-image" src="' + head.image.uri+ '" alt="cover image">\n' +
                                '</div>\n';
                        } else {
                          thumb = head.image.uri;  
                        }
                    });
                    
                    htmlString += '<div class="col-12 news-lead linear-gradient-bottom">' + 
                        '\n<h2>' + news.headline + '</h2>\n' +
                        '<div>\n';
                    
                    if (thumb != null) {
                        htmlString += '<div class="float-right thumb-image position-relative">\n' +
                            '<img class="w-100 h-100" src="' + thumb + '" alt="thumbnail">\n' +
                            '</div>';
                        console.log("this is the thumb: " + thumb);
                        thumb = null;
                    }
                    
                    htmlString += news.lead +
                        '\n</div>\n' +
                        '<div>' + news.created + '\n&nbsp;<a href="' + path + '/news/' + news.id + '">Read more</a>\n';
                    
                    if (principal === news.author.ssoId) {
                        htmlString +=
                            ' | <a href="' + path + '/news/' + news.id + '/edit">Edit</a> | \n'+
                            '<form style="display: inline" method="POST" action="' + path + '/news/'+news.id+'">\n' +
                                '<input type="hidden" name="_method" value="DELETE"/>\n' +
                                '<button type="submit">Delete</button>\n' +
                                '<input type="hidden" name="' + csrfParameterName + '" value="' + csrfToken + '" />\n' +
                            '</form>\n';
                    }
                    
                    htmlString += '</div></div></div><hr class="thick">';
                    
                    console.log('This is the final htmlString: ' + htmlString);
                    
                    $('#moreNews').append(htmlString);
                    
                    
//                    $('#moreNews').append(
//                        '<br><br>' +
//                        '<img src="' + '#' +'" style="border: 1px solid black">' +
//                        '<h2>' + news.headline + '</h2>' +
//                        '<div>' + news.lead + '</div>' +
//                        '<div>' + news.created +'</div>' +
//                        '<a href="' + path+ '/news/' + news.id + '">Read more</a>');
//                    
//                    if (principal === news.author.ssoId) {
//                        $('#moreNews').append(
//                            ' | <a href="' + path + '/news/' + news.id + '/edit">Edit</a> | '+
//                            '<form style="display: inline" method="POST" action="' + path + '/news/'+news.id+'">' +
//                                '<input type="hidden" name="_method" value="DELETE"/>' +
//                                '<button type="submit">Delete</button>' +
//                                '<input type="hidden" name="' + csrfParameterName + '" value="' + csrfToken + '" />' +
//                            '</form>'         
//                        );
//                    }
                    
                });
            },
            statusCode: {
                404: function() {
                    console.log("404: not found!");
                },
                204: function() {
                    console.log("204: no content")
                }
            }
        }
        
        $.get(settings);
        
        
    });
    
    function getPrincipal() {
        console.log("inside getPrincipal()")
        var settings = {
            url: path + '/users/authenticated',
            dataType: 'json',
            contentType: 'application/json',
            success: function(data) {
                console.log("request to '/users/authenticated' was successful");
                principal = data['username'];
                console.log("principal is: " + principal);
            }
        }
        $.get(settings);
    }
});