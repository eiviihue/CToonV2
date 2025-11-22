<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${comic.title} - Chapter ${chapter.number}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <script src="${pageContext.request.contextPath}/js/theme.js"></script>
    <style>
        .chapter-container {
            max-width: 900px;
            margin: 40px auto;
            padding: 0 20px;
        }

        .chapter-header {
            text-align: center;
            margin-bottom: 40px;
            padding-bottom: 20px;
        }

        .chapter-header h1 {
            margin-bottom: 10px;
        }

        .chapter-header h2 {
            margin-bottom: 5px;
        }

        .chapter-meta {
            color: #666;
            font-size: 0.9em;
        }

        .pages-container {
            display: flex;
            flex-direction: column;
            gap: 20px;
            margin-bottom: 40px;
        }

        .page-item {
            width: 100%;
        }

        .page-image {
            width: 100%;
            height: auto;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        .no-pages {
            text-align: center;
            padding: 40px;
            background: #f5f5f5;
            border-radius: 8px;
            color: #666;
        }

        body.dark-mode .no-pages {
            background: #2a2a3e;
            color: #e0e0e0;
        }

        .comments-section {
            margin-top: 60px;
            padding: 20px;
            background: #f5f5f5;
            border-radius: 8px;
        }
        
        body.dark-mode .comments-section {
            background: #2a2a3e;
        }

        .comments-section h3 {
            margin-bottom: 20px;
        }

        .comments-list {
            margin-top: 20px;
        }

        @media (max-width: 768px) {
            .chapter-container {
                margin: 20px auto;
                padding: 0 10px;
            }
        }
    </style>
</head>
<body>
    <%@ include file="navbar.jsp" %>
    
    <div class="chapter-container">
        <div class="chapter-header">
            <h1>${comic.title}</h1>
            <h2>Chapter ${chapter.number}: ${chapter.title}</h2>
            <p class="chapter-meta">By ${comic.author}</p>
        </div>

        <!-- Pages Display -->
        <div class="pages-container">
            <c:choose>
                <c:when test="${not empty pages}">
                    <c:forEach items="${pages}" var="page">
                        <div class="page-item">
                            <img src="${pageContext.request.contextPath}${page.imagePath}" 
                                 alt="Page ${page.pageNumber}" 
                                 class="page-image">
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="no-pages">
                        <p>No pages available for this chapter.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Comments Section -->
        <div class="comments-section">
            <h3>Comments</h3>
            <div class="comments-list">
                <p>No comments available. Be the first to read this chapter!</p>
            </div>
        </div>
            <c:set var="prevChapter" value="" />
            <c:set var="nextChapter" value="" />
            <c:if test="${not empty chapters}">
                <c:forEach items="${chapters}" var="ch" varStatus="st">
                    <c:if test="${ch.id == chapter.id}">
                        <c:if test="${st.index > 0}">
                            <c:set var="prevChapter" value="${chapters[st.index - 1]}" />
                        </c:if>
                        <c:if test="${st.index lt fn:length(chapters) - 1}">
                            <c:set var="nextChapter" value="${chapters[st.index + 1]}" />
                        </c:if>
                    </c:if>
                </c:forEach>
            </c:if>

            <!-- Navigation buttons -->
            <div class="btn-group" style="text-align: center; margin: 3rem 0; justify-content: center;">
                <c:choose>
                    <c:when test="${not empty prevChapter}">
                        <a href="${pageContext.request.contextPath}/chapter?id=${prevChapter.id}" class="btn btn-secondary">← Previous</a>
                    </c:when>
                    <c:otherwise>
                        <button class="btn btn-secondary" disabled style="opacity: 0.5; cursor: not-allowed;">← Previous</button>
                    </c:otherwise>
                </c:choose>

                <a href="${pageContext.request.contextPath}/comic-detail?id=${comic.id}" class="btn">Back to Comic</a>

                <c:choose>
                    <c:when test="${not empty nextChapter}">
                        <a href="${pageContext.request.contextPath}/chapter?id=${nextChapter.id}" class="btn">Next →</a>
                    </c:when>
                    <c:otherwise>
                        <button class="btn" disabled style="opacity: 0.5; cursor: not-allowed;">Next →</button>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </body>
    </html>
