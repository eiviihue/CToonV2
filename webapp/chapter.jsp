<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${comic.title} - Chapter ${chapter.number}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <%@ include file="navbar.jsp" %>
    
    <div class="chapter-container">
        <div class="chapter-header">
            <h1>${comic.title}</h1>
            <h2>Chapter ${chapter.number}: ${chapter.title}</h2>
            <p class="chapter-meta">By ${comic.author}</p>
        </div>

        <!-- Chapter Navigation -->
        <div class="chapter-nav">
            <c:forEach items="${chapters}" var="ch">
                <c:choose>
                    <c:when test="${ch.id == chapter.id}">
                        <button class="chapter-btn active">Chapter ${ch.number}</button>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/chapter?id=${ch.id}" class="chapter-btn">
                            Chapter ${ch.number}
                        </a>
                    </c:otherwise>
                </c:choose>
            </c:forEach>
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
            <div class="comment-form">
                <textarea placeholder="Share your thoughts..."></textarea>
                <button class="btn-primary">Post Comment</button>
            </div>
            <div class="comments-list">
                <p>No comments yet. Be the first to comment!</p>
            </div>
        </div>
    </div>

    <style>
        .chapter-container {
            max-width: 900px;
            margin: 40px auto;
            padding: 0 20px;
        }

        .chapter-header {
            text-align: center;
            margin-bottom: 40px;
            border-bottom: 2px solid var(--primary-color);
            padding-bottom: 20px;
        }

        .chapter-header h1 {
            color: var(--primary-color);
            margin-bottom: 10px;
        }

        .chapter-header h2 {
            color: var(--text-color);
            margin-bottom: 5px;
        }

        .chapter-meta {
            color: var(--text-secondary);
            font-size: 0.9em;
        }

        .chapter-nav {
            display: flex;
            gap: 10px;
            margin-bottom: 40px;
            flex-wrap: wrap;
            justify-content: center;
        }

        .chapter-btn {
            padding: 8px 16px;
            border: 2px solid var(--primary-color);
            background: transparent;
            color: var(--primary-color);
            border-radius: 5px;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
        }

        .chapter-btn:hover {
            background: var(--primary-color);
            color: white;
        }

        .chapter-btn.active {
            background: var(--primary-color);
            color: white;
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
            background: var(--bg-secondary);
            border-radius: 8px;
            color: var(--text-secondary);
        }

        .comments-section {
            margin-top: 60px;
            padding: 20px;
            background: var(--bg-secondary);
            border-radius: 8px;
        }

        .comments-section h3 {
            color: var(--primary-color);
            margin-bottom: 20px;
        }

        .comment-form {
            margin-bottom: 30px;
        }

        .comment-form textarea {
            width: 100%;
            padding: 12px;
            border: 1px solid var(--border-color);
            border-radius: 5px;
            background: var(--bg-primary);
            color: var(--text-color);
            font-family: inherit;
            margin-bottom: 10px;
            min-height: 100px;
            resize: vertical;
        }

        .comment-form textarea:focus {
            outline: none;
            border-color: var(--primary-color);
        }

        .comments-list {
            margin-top: 20px;
        }

        /* Dark mode support */
        .dark-mode .chapter-container {
            color: var(--text-color);
        }

        @media (max-width: 768px) {
            .chapter-container {
                margin: 20px auto;
            }

            .chapter-nav {
                gap: 5px;
            }

            .chapter-btn {
                padding: 6px 12px;
                font-size: 0.9em;
            }
        }
    </style>

    <script src="${pageContext.request.contextPath}/js/theme.js"></script>
</body>
</html>
                <div style="margin-bottom: 1.5rem;">
                    <strong>ComicFan99</strong> <span style="color: #999; font-size: 0.9rem;">1 day ago</span>
                    <p>Wow! That plot twist was insane! Can't wait for the next chapter!</p>
                </div>
                <div style="margin-bottom: 1.5rem;">
                    <strong>MangaReader</strong> <span style="color: #999; font-size: 0.9rem;">2 days ago</span>
                    <p>The art in this chapter is absolutely stunning. The action sequences are perfectly drawn!</p>
                </div>
                <div>
                    <strong>StoryLover</strong> <span style="color: #999; font-size: 0.9rem;">3 days ago</span>
                    <p>This is becoming my favorite manga! The character development is amazing!</p>
                </div>
            </div>
        </div>

        <div style="text-align: center; margin: 3rem 0; display: flex; gap: 1rem; justify-content: center;">
            <button class="btn btn-secondary">← Previous Chapter</button>
            <a href="${pageContext.request.contextPath}/comic.jsp" class="btn">Back to Comic</a>
            <button class="btn">Next Chapter →</button>
        </div>
    </main>
    
    <footer>
        <button id="theme-toggle">🌙 Dark Mode</button>
    </footer>
</body>
</html>
