package model;

public class Rating {
    private int id;
    private int userId;
    private int comicId;
    private int stars; // 1-5

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public int getComicId() { return comicId; }
    public void setComicId(int comicId) { this.comicId = comicId; }
    public int getStars() { return stars; }
    public void setStars(int stars) { this.stars = stars; }
}
package model;

public class Rating {
    private int id;
    private int userId;
    private int comicId;
    private int stars; // 1-5

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getComicId() {
        return comicId;
    }

    public void setComicId(int comicId) {
        this.comicId = comicId;
    }

    public int getStars() {
        return stars;
    }

    public void setStars(int stars) {
        this.stars = stars;
    }
}
